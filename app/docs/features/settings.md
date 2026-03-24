# Settings Page

앱 리뷰, 공유, 약관/개인정보처리방침 링크를 포함하는 설정 페이지입니다.

## 위치

```
lib/app/ui/pages/settings/settings_page.dart
```

## 기본 제공 기능

- 앱 리뷰 남기기 (`in_app_review`)
- 친구에게 공유 (`share_plus`)
- 이용약관 링크
- 개인정보처리방침 링크
- 7탭 이스터에그로 DevTools 페이지 진입

## 확장하기

`SettingsPage`를 상속하여 `buildExtraSettingsSections()`를 오버라이드하면 "기타" 섹션 위에 앱 고유 설정을 추가할 수 있습니다:

```dart
class MySettingsPage extends SettingsPage {
  const MySettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _MySettingsPageState();
}

class _MySettingsPageState extends _SettingsPageState {
  @override
  List<Widget> buildExtraSettingsSections(BuildContext context) {
    return [
      // 여기에 앱 고유 설정 섹션 추가
      const SizedBox(height: AppSizes.spacingXl),
    ];
  }
}
```

## URL 설정

`lib/resources/app_config.dart`에서 스토어 ID와 URL을 설정합니다:

```dart
static const appStoreId = '1234567890';
static const playStoreId = 'com.example.myapp';
static const termsUrl = 'https://example.com/terms';
static const privacyPolicyUrl = 'https://example.com/privacy';
```
