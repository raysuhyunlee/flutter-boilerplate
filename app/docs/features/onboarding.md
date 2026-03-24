# Onboarding

첫 실행 시 표시되는 스와이프형 온보딩 페이지입니다.

## 위치

```
lib/app/ui/pages/onboarding/onboarding_page.dart
```

## 구조

`OnboardingPage`는 `OnboardingStep` 리스트를 받아 PageView로 렌더링합니다.

```dart
class OnboardingStep {
  final Widget visual;    // 상단 비주얼 위젯 (이미지, 애니메이션 등)
  final String title;     // 제목
  final String description; // 설명
}
```

## 사용법

### 기본 사용 (app.dart에 이미 설정됨)

`_EntryPoint` 위젯에서 `SessionService.isFirstLaunch()`를 확인하고, 최초 실행이면 `OnboardingPage`를 표시합니다.

### 온보딩 스텝 커스터마이징

`app.dart`의 `_buildOnboardingSteps()` 메서드를 수정합니다:

```dart
List<OnboardingStep> _buildOnboardingSteps(BuildContext context) {
  return [
    OnboardingStep(
      visual: Image.asset('assets/images/onboarding1.png',
          width: double.infinity, fit: BoxFit.cover),
      title: '첫 번째 화면 제목',
      description: '설명 텍스트',
    ),
    OnboardingStep(
      visual: const MyCustomAnimation(),
      title: '두 번째 화면',
      description: '어떤 위젯이든 visual로 사용할 수 있습니다.',
    ),
  ];
}
```

### 알림 권한 요청 (선택)

마지막 스텝에서 알림 권한을 요청하려면 `onRequestPermission`을 전달합니다:

```dart
OnboardingPage(
  steps: steps,
  onComplete: _onOnboardingComplete,
  onRequestPermission: () async {
    // 알림 권한 요청 로직
    await notificationService.requestPermission();
  },
  lastStepCtaText: '알림 허용하고 시작하기',
  lastStepSkipText: '알림 설정 안 함',
)
```

`onRequestPermission`이 null이면 마지막 스텝은 단순히 "시작하기" 버튼을 표시합니다.

## UI 요소

- **페이지 인디케이터**: 마지막 페이지를 제외한 모든 페이지에 표시
- **CTA 버튼**: `CtaButton` 위젯 사용 (로딩 상태 지원)
- **스킵 링크**: 마지막 페이지에서 알림 권한 스킵 옵션
