#!/bin/bash

# =============================================================================
# Flutter Boilerplate - Package Rename Script
# =============================================================================
#
# Usage:
#   ./scripts/rename.sh <package_name> <app_name>
#
# Example:
#   ./scripts/rename.sh com.mycompany.coolapp "Cool App"
#
# This script changes:
#   - Android applicationId & namespace
#   - Android Kotlin package directory & declarations
#   - Android app display name
#   - Android method channel name
#   - iOS bundle identifier
#   - iOS app display name
#   - Dart package name & all import paths
#   - pubspec.yaml name
# =============================================================================

set -e

# --- Color helpers ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# --- Validate arguments ---
NEW_PACKAGE=$1
APP_NAME=$2

if [ -z "$NEW_PACKAGE" ] || [ -z "$APP_NAME" ]; then
  echo "Usage: ./scripts/rename.sh <package_name> <app_name>"
  echo ""
  echo "  package_name  Android applicationId / iOS bundle identifier"
  echo "                (e.g., com.mycompany.coolapp)"
  echo "  app_name      Display name shown to users"
  echo "                (e.g., \"Cool App\")"
  echo ""
  echo "Example:"
  echo "  ./scripts/rename.sh com.mycompany.coolapp \"Cool App\""
  exit 1
fi

# Validate package name format
if ! echo "$NEW_PACKAGE" | grep -qE '^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)+$'; then
  error "Invalid package name: '$NEW_PACKAGE'\nPackage name must be lowercase, dot-separated (e.g., com.example.myapp)"
fi

# --- Derived values ---
# Dart package name = last segment of package name
DART_PACKAGE=$(echo "$NEW_PACKAGE" | awk -F. '{print $NF}')

# Boilerplate defaults
OLD_PACKAGE="com.example.flutterboilerplate"
OLD_DART_PACKAGE="flutter_boilerplate"
OLD_APP_NAME="Flutter Boilerplate"

# Platform-aware sed in-place
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed_i() { sed -i '' "$@"; }
else
  sed_i() { sed -i "$@"; }
fi

# --- Navigate to project root ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

info "Project root: $PROJECT_ROOT"
info "New package:  $NEW_PACKAGE"
info "App name:     $APP_NAME"
info "Dart package: $DART_PACKAGE"
echo ""

# =============================================================================
# 1. Update pubspec.yaml
# =============================================================================
info "Updating pubspec.yaml..."
sed_i "s/^name: $OLD_DART_PACKAGE$/name: $DART_PACKAGE/" pubspec.yaml

# =============================================================================
# 2. Update Dart imports
# =============================================================================
info "Updating Dart import paths..."
find lib test -name '*.dart' 2>/dev/null | while read -r file; do
  sed_i "s|package:$OLD_DART_PACKAGE/|package:$DART_PACKAGE/|g" "$file"
done

# =============================================================================
# 3. Update Android method channel (before change_app_package_name moves files)
# =============================================================================
info "Updating Android method channel..."
MAIN_ACTIVITY=$(find android -name 'MainActivity.kt' 2>/dev/null | head -1)
if [ -n "$MAIN_ACTIVITY" ]; then
  sed_i "s|$OLD_PACKAGE/share|$NEW_PACKAGE/share|g" "$MAIN_ACTIVITY"
fi

# =============================================================================
# 4. Android package rename via change_app_package_name
# =============================================================================
info "Running flutter pub get..."
flutter pub get

info "Renaming Android package to $NEW_PACKAGE..."
dart run change_app_package_name:main "$NEW_PACKAGE"

# =============================================================================
# 5. Update iOS bundle identifier
# =============================================================================
info "Updating iOS bundle identifier..."
PBXPROJ="ios/Runner.xcodeproj/project.pbxproj"
sed_i "s/$OLD_PACKAGE/$NEW_PACKAGE/g" "$PBXPROJ"

# Also update RunnerTests bundle identifier
sed_i "s/${OLD_PACKAGE}\.RunnerTests/${NEW_PACKAGE}.RunnerTests/g" "$PBXPROJ"

# =============================================================================
# 6. Update app display name - iOS
# =============================================================================
info "Updating iOS app display name..."

# Info.plist - CFBundleDisplayName & CFBundleName
sed_i "s|<string>$OLD_APP_NAME</string>|<string>$APP_NAME</string>|g" ios/Runner/Info.plist

# project.pbxproj - INFOPLIST_KEY_CFBundleDisplayName
# Handle both quoted and unquoted values
sed_i "s|INFOPLIST_KEY_CFBundleDisplayName = \"$OLD_APP_NAME\";|INFOPLIST_KEY_CFBundleDisplayName = \"$APP_NAME\";|g" "$PBXPROJ"

# =============================================================================
# 7. Update app display name - Android
# =============================================================================
info "Updating Android app display name..."
sed_i "s|\"app_name\", \"${OLD_APP_NAME}\"|\"app_name\", \"${APP_NAME}\"|g" android/app/build.gradle

# =============================================================================
# 8. Update iOS GoogleService-Info.plist bundle ID
# =============================================================================
info "Updating GoogleService-Info.plist bundle ID..."
GOOGLE_PLIST="ios/Runner/GoogleService-Info.plist"
if [ -f "$GOOGLE_PLIST" ]; then
  sed_i "s|<string>$OLD_PACKAGE</string>|<string>$NEW_PACKAGE</string>|g" "$GOOGLE_PLIST"
fi

# =============================================================================
# Done
# =============================================================================
echo ""
info "Rename complete!"
echo ""
echo "Next steps:"
echo "  1. Set up Firebase:"
echo "     dart pub global activate flutterfire_cli"
echo "     flutterfire configure"
echo ""
echo "  2. Run the app:"
echo "     flutter pub get"
echo "     flutter run"
echo ""
