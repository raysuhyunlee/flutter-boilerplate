# 시작하기

## 1. Clone 및 이름 변경

```sh
git clone <repo-url> my_app
cd my_app/app
./scripts/rename.sh <package_name> <app_name>
```

예시:
```sh
./scripts/rename.sh com.mycompany.coolapp "Cool App"
```

이 스크립트는 다음 항목을 자동으로 업데이트합니다:
- Android `applicationId` 및 `namespace`
- Android Kotlin 패키지 디렉토리 및 선언
- Android 앱 표시 이름
- iOS `bundle identifier`
- iOS 앱 표시 이름
- Dart 패키지 이름(`pubspec.yaml`의 `name`) 및 모든 `import` 경로
- Method channel 이름

## 2. Firebase 설정

Firebase 프로젝트를 생성한 후 FlutterFire CLI로 설정 파일을 생성합니다.

```sh
# FlutterFire CLI 설치 (최초 1회)
dart pub global activate flutterfire_cli

# Firebase 설정 파일 생성 (app/ 내에서 실행)
cd app
flutterfire configure
```

이 명령어는 다음 파일들을 자동 생성합니다:
- `app/lib/firebase_options.dart`
- `app/android/app/google-services.json`
- `app/ios/Runner/GoogleService-Info.plist`

## 3. AppConfig 설정

`app/lib/resources/app_config.dart`에서 앱별 설정값을 채워넣습니다:

```dart
static const appStoreId = '1234567890';
static const playStoreId = 'com.example.myapp';
static const termsUrl = 'https://example.com/terms';
static const privacyPolicyUrl = 'https://example.com/privacy';
static const revenueCatApiKey = 'your_key';  // 사용하지 않으면 빈 문자열
```

## 4. Android 서명 키

Release 빌드를 위한 keystore를 생성합니다. (이미 있다면 건너뛰세요.)

```sh
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

`app/android/key.properties.example`을 `app/android/key.properties`로 복사한 뒤 값을 입력합니다.

```sh
cp app/android/key.properties.example app/android/key.properties
```

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=/path/to/your/upload-keystore.jks
```

## 5. 의존성 설치 및 실행

```sh
cd app
flutter pub get
flutter run
```

## 6. 앱 아이콘 변경

`app/assets/app_icon.png`를 원하는 아이콘으로 교체한 후 생성합니다.

```sh
cd app
dart run flutter_launcher_icons
```

# 자주 사용하는 명령어

아래 명령어는 모두 `app/` 디렉토리에서 실행합니다.

```sh
# 실행
flutter run

# 포맷팅
dart fix --apply
flutter pub run import_sorter:main

# 다국어 생성
flutter gen-l10n

# Release 빌드 (pubspec.yaml에서 version code 증가 후)
flutter build appbundle   # Android → build/app/outputs/bundle/release/app-release.aab
flutter build ipa         # iOS
```
