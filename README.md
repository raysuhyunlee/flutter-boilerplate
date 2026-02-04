# Flutter Boilerplate

A Flutter boilerplate pre-configured with Firebase Analytics, Crashlytics, and DI (GetIt).

## Features

- Firebase Analytics / Crashlytics
- GetIt-based dependency injection
- SQLite local database
- Theme and common widgets (Snackbar, Dialog, CachedImage, etc.)
- Release build script

## Getting Started

### 1. Clone and Rename

```sh
git clone <repo-url> my_app
cd my_app
```

Run the rename script to change the package name and app display name.

```sh
./scripts/rename.sh <package_name> <app_name>
```

Example:
```sh
./scripts/rename.sh com.mycompany.coolapp "Cool App"
```

This script automatically updates:
- Android `applicationId` and `namespace`
- Android Kotlin package directory and declarations
- Android app display name
- iOS `bundle identifier`
- iOS app display name
- Dart package name (`pubspec.yaml` `name`) and all `import` paths
- Method channel name

### 2. Firebase Setup

Create a Firebase project, then generate config files using FlutterFire CLI.

```sh
# Install FlutterFire CLI (one-time)
dart pub global activate flutterfire_cli

# Generate Firebase config files
flutterfire configure
```

This command auto-generates the following files:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `ios/firebase_app_id_file.json`

### 3. Android Signing Key

Generate a keystore for release builds. (Skip if you already have one.)

```sh
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Copy `android/key.properties.example` to `android/key.properties` and fill in your values.

```sh
cp android/key.properties.example android/key.properties
```

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=/path/to/your/upload-keystore.jks
```

### 4. Install Dependencies and Run

```sh
flutter pub get
flutter run
```

### 5. Change App Icon

Replace `assets/app_icon.png` with your icon, then generate.
```sh
dart run flutter_launcher_icons
```

## Frequently Used Commands

### Running

```sh
flutter run
```

### Formatting

```sh
dart fix --apply
flutter pub run import_sorter:main
```

### Release Build

```yaml
# pubspec.yaml
version: x.y.z+[version_code] # increment the version code
```

```sh
. scripts/build.sh
```
