# Flutter Boilerplate

Firebase Analytics, Crashlytics, DI(GetIt)가 사전 구성된 Flutter 보일러플레이트입니다.

## 프로젝트 구조

```
├── analytics/   # 앱 분석 리포트 및 데이터
├── docs/        # 경쟁 분석, 기획 문서
├── design/      # 디자인 에셋, 목업, 스크린샷
│   ├── mockups/
│   └── screenshots/
├── app/         # Flutter 소스 코드
│   ├── lib/
│   ├── test/
│   ├── android/
│   ├── ios/
│   └── ...
└── CLAUDE.md
```

> **참고:** 모든 Flutter CLI 명령어(`flutter run`, `flutter test` 등)는 `app/` 디렉토리 안에서 실행해야 합니다.

## 주요 기능

- Firebase Analytics / Crashlytics
- GetIt 기반 dependency injection
- SQLite 로컬 데이터베이스
- 테마 및 공통 위젯 (Snackbar, Dialog, CachedImage 등)
- Release 빌드 스크립트

## 시작하기

### 1. Clone 및 이름 변경

```sh
git clone <repo-url> my_app
cd my_app/app
```

rename 스크립트를 실행하여 패키지 이름과 앱 표시 이름을 변경합니다.

```sh
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

### 2. Firebase 설정

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
- `app/ios/firebase_app_id_file.json`

### 3. Android 서명 키

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

### 4. 의존성 설치 및 실행

```sh
cd app
flutter pub get
flutter run
```

### 5. 앱 아이콘 변경

`app/assets/app_icon.png`를 원하는 아이콘으로 교체한 후 생성합니다.
```sh
cd app
dart run flutter_launcher_icons
```

## 자주 사용하는 명령어

아래 명령어는 모두 `app/` 디렉토리에서 실행합니다.

### 실행

```sh
flutter run
```

### 포맷팅

```sh
dart fix --apply
flutter pub run import_sorter:main
```

### Release 빌드

`app/android/` 하위에 `key.properties` 파일을 생성합니다.
예시 파일을 참고하세요.

```yaml
# pubspec.yaml
version: x.y.z+[version_code] # version code를 증가시킵니다
```

```sh
# android
flutter build appbundle
# build/app/outputs/bundle/release/app-release.aab

# ios
flutter build ipa
```
