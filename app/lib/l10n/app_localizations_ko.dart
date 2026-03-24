// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '앱';

  @override
  String get helloBoilerplate => '안녕하세요, 보일러플레이트!';

  @override
  String get settings => '설정';

  @override
  String get termsOfUse => '이용약관';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String get settingsOther => '기타';

  @override
  String get settingsReview => '앱 리뷰 남기기';

  @override
  String get settingsShare => '친구에게 공유';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingStart => '시작하기';

  @override
  String get onboardingAllowNotifications => '알림 허용하고 시작하기';

  @override
  String get onboardingSkipNotifications => '알림 설정 안 함';

  @override
  String get onboardingStep1Title => '환영합니다!';

  @override
  String get onboardingStep1Description => '새로운 앱을 시작해보세요.';

  @override
  String get paywallTitle => 'PRO 잠금 해제';

  @override
  String get paywallFeature1 => '프리미엄 기능';

  @override
  String get paywallFeature2 => '광고 없는 깔끔한 앱';

  @override
  String get paywallFeature3 => '무제한 이용';

  @override
  String get paywallTrialTitle => '무료 체험';

  @override
  String paywallTrialSubtitle(String price) {
    return '이후 $price/월';
  }

  @override
  String get paywallTrialBadge => '무료 체험';

  @override
  String get paywallLifetimeTitle => '평생 이용권';

  @override
  String get paywallCtaTrial => '무료로 시작하기';

  @override
  String get paywallCtaLifetime => '지금 잠금 해제';

  @override
  String get paywallRestore => '구매 복원';

  @override
  String get devToolsSessionSection => '세션';

  @override
  String get devToolsSessionCount => '세션 횟수';

  @override
  String devToolsSessionCountUpdated(int count) {
    return '세션 횟수가 $count으로 설정되었습니다.';
  }

  @override
  String get devToolsResetSection => '초기화';

  @override
  String get devToolsResetButton => '세션 초기화 (첫 설치 상태로)';

  @override
  String get devToolsResetComplete => '초기화가 완료되었습니다.';

  @override
  String get devToolsError => '오류';
}
