# Subscription & Paywall (RevenueCat)

RevenueCat 기반 구독/결제 관리 및 페이월 UI를 제공합니다.

## 파일 구조

```
lib/domain/subscription/subscription_repository.dart  — 구독 비즈니스 로직
lib/app/ui/pages/paywall/paywall_page.dart             — 페이월 UI
lib/resources/app_config.dart                           — API 키, Entitlement ID 설정
```

## 초기 설정

### 1. RevenueCat 대시보드 설정

1. [RevenueCat](https://www.revenuecat.com/) 에서 프로젝트 생성
2. App Store / Play Store 연동
3. Entitlement, Offering, Package 설정

### 2. AppConfig 업데이트

`lib/resources/app_config.dart`에서 값을 채워넣습니다:

```dart
static const revenueCatApiKey = 'your_api_key_here';
static const revenueCatEntitlementId = 'pro';  // 또는 원하는 이름
```

### 3. pubspec.yaml

이미 추가되어 있습니다:
```yaml
purchases_flutter: ^8.0.0
```

## 사용법

### 페이월 표시

```dart
// 닫기 가능한 페이월
final purchased = await PaywallPage.show(context);

// 강제 페이월 (닫기 불가)
final purchased = await PaywallPage.show(context, dismissible: false);

// 커스텀 기능 목록
final purchased = await PaywallPage.show(
  context,
  features: [
    PaywallFeature(label: '무제한 저장', icon: Icons.save),
    PaywallFeature(label: '광고 제거', icon: Icons.block),
  ],
);
```

### 구독 상태 확인

```dart
final repo = GetIt.instance<SubscriptionRepository>();
final isPro = await repo.isProUser();
```

### 페이월 트리거 평가

세션 수 기반으로 페이월 표시 전략을 결정합니다:

```dart
final trigger = await repo.evaluatePaywallTrigger(forcedAfterSessions: 10);
switch (trigger) {
  case PaywallTrigger.none:
    break; // Pro 사용자이거나 초기화 안 됨
  case PaywallTrigger.dismissiblePaywall:
    PaywallPage.show(context, dismissible: true);
  case PaywallTrigger.forcedPaywall:
    PaywallPage.show(context, dismissible: false);
}
```

### 구매 복원

```dart
await repo.restorePurchases();
```

## 비활성화

RevenueCat을 사용하지 않으려면 `AppConfig.revenueCatApiKey`를 빈 문자열로 두면 됩니다. `SubscriptionRepository.initialize()`가 자동으로 스킵됩니다.

## 지원하는 패키지 타입

- **Trial** — 무료 체험 후 월간 구독
- **Lifetime** — 일회성 영구 구매

RevenueCat Offering에 설정된 Package가 자동으로 카드로 표시됩니다.
