// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'App';

  @override
  String get helloBoilerplate => 'Hello, Boilerplate!';

  @override
  String get settings => 'Settings';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get settingsOther => 'Other';

  @override
  String get settingsReview => 'Leave a Review';

  @override
  String get settingsShare => 'Share with Friends';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get Started';

  @override
  String get onboardingAllowNotifications => 'Allow Notifications & Start';

  @override
  String get onboardingSkipNotifications => 'Skip notifications';

  @override
  String get onboardingStep1Title => 'Welcome!';

  @override
  String get onboardingStep1Description => 'Get started with your new app.';

  @override
  String get paywallTitle => 'Unlock PRO';

  @override
  String get paywallFeature1 => 'Premium features';

  @override
  String get paywallFeature2 => 'Ad-free experience';

  @override
  String get paywallFeature3 => 'Unlimited access';

  @override
  String get paywallTrialTitle => 'Free Trial';

  @override
  String paywallTrialSubtitle(String price) {
    return 'Then $price/month';
  }

  @override
  String get paywallTrialBadge => 'Free Trial';

  @override
  String get paywallLifetimeTitle => 'Lifetime';

  @override
  String get paywallCtaTrial => 'Start Free Trial';

  @override
  String get paywallCtaLifetime => 'Unlock Now';

  @override
  String get paywallRestore => 'Restore Purchases';

  @override
  String get devToolsSessionSection => 'Session';

  @override
  String get devToolsSessionCount => 'Session Count';

  @override
  String devToolsSessionCountUpdated(int count) {
    return 'Session count set to $count.';
  }

  @override
  String get devToolsResetSection => 'Reset';

  @override
  String get devToolsResetButton => 'Reset to First Install State';

  @override
  String get devToolsResetComplete => 'Reset complete.';

  @override
  String get devToolsError => 'Error';
}
