# Dev Tools Page

디버깅용 개발자 전용 페이지입니다. 설정 페이지 제목을 7번 탭하면 진입합니다.

## 위치

```
lib/app/ui/pages/settings/dev_tools_page.dart
```

## 기본 제공 기능

- **세션 횟수** 조회/수동 설정
- **세션 초기화** — SharedPreferences 전체 클리어 (첫 설치 상태로 복원)

## 확장하기

`DevToolsPage`를 상속하여 `buildExtraSections()`를 오버라이드하면 앱 고유 디버그 도구를 추가할 수 있습니다:

```dart
class MyDevToolsPage extends DevToolsPage {
  const MyDevToolsPage({super.key});

  @override
  State<DevToolsPage> createState() => _MyDevToolsPageState();
}

class _MyDevToolsPageState extends _DevToolsPageState {
  @override
  List<Widget> buildExtraSections(BuildContext context) {
    return [
      const SizedBox(height: AppSizes.spacingLg),
      _buildSection('알림 관리', [
        _buildButton('테스트 알림 발송', _sendTestNotification),
        _buildButton('모든 알림 취소', _cancelAll),
      ]),
    ];
  }
}
```

## 접근 방법

설정 페이지 → "설정" 제목 텍스트를 7번 연속 탭

> **참고:** Release 빌드에서는 `kDebugMode` 체크를 추가하여 비활성화하는 것을 권장합니다.
