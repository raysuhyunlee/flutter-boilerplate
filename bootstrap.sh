#!/bin/bash

# =============================================================================
# Flutter Boilerplate - Bootstrap Script
# =============================================================================
#
# Sets up a new project from the boilerplate:
#   1. Reconfigures git remotes (your origin + boilerplate as "boiler")
#   2. Guides you to run the rename script
#
# Usage:
#   ./bootstrap.sh
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

BOILERPLATE_URL="git@github.com:raysuhyunlee/flutter-boilerplate.git"

# =============================================================================
# 1. Configure git remotes
# =============================================================================
echo ""
info "Git remote setup"
echo ""

read -rp "Enter your new git origin URL: " NEW_ORIGIN

if [ -z "$NEW_ORIGIN" ]; then
  error "Origin URL cannot be empty."
fi

info "Setting remote 'boiler'..."
if git remote get-url boiler &>/dev/null; then
  warn "'boiler' remote already exists, updating URL..."
  git remote set-url boiler "$BOILERPLATE_URL"
else
  git remote rename origin boiler
fi

info "Adding new origin: $NEW_ORIGIN"
if git remote get-url origin &>/dev/null; then
  git remote set-url origin "$NEW_ORIGIN"
else
  git remote add origin "$NEW_ORIGIN"
fi

echo ""
info "Git remotes configured:"
git remote -v
echo ""

# =============================================================================
# 2. Guide to rename script
# =============================================================================
info "Next step: rename the app package and display name."
echo ""
echo "  cd app && ./scripts/rename.sh <package_name> <app_name>"
echo ""
echo "  Example:"
echo "    cd app && ./scripts/rename.sh com.mycompany.coolapp \"Cool App\""
echo ""
