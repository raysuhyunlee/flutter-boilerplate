import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get appTitle;

  /// Greeting message on the home screen
  ///
  /// In en, this message translates to:
  /// **'Hello, Boilerplate!'**
  String get helloBoilerplate;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Terms of use menu item
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// Privacy policy menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Other section label in settings
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get settingsOther;

  /// Review app button in settings
  ///
  /// In en, this message translates to:
  /// **'Leave a Review'**
  String get settingsReview;

  /// Share app button in settings
  ///
  /// In en, this message translates to:
  /// **'Share with Friends'**
  String get settingsShare;

  /// Next button on onboarding pages
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Start button on last onboarding page without permissions
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingStart;

  /// CTA on last onboarding page requesting notification permission
  ///
  /// In en, this message translates to:
  /// **'Allow Notifications & Start'**
  String get onboardingAllowNotifications;

  /// Skip link on last onboarding page
  ///
  /// In en, this message translates to:
  /// **'Skip notifications'**
  String get onboardingSkipNotifications;

  /// Default onboarding step 1 title
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get onboardingStep1Title;

  /// Default onboarding step 1 description
  ///
  /// In en, this message translates to:
  /// **'Get started with your new app.'**
  String get onboardingStep1Description;

  /// Paywall hero title
  ///
  /// In en, this message translates to:
  /// **'Unlock PRO'**
  String get paywallTitle;

  /// Default paywall feature 1
  ///
  /// In en, this message translates to:
  /// **'Premium features'**
  String get paywallFeature1;

  /// Default paywall feature 2
  ///
  /// In en, this message translates to:
  /// **'Ad-free experience'**
  String get paywallFeature2;

  /// Default paywall feature 3
  ///
  /// In en, this message translates to:
  /// **'Unlimited access'**
  String get paywallFeature3;

  /// Trial package card title
  ///
  /// In en, this message translates to:
  /// **'Free Trial'**
  String get paywallTrialTitle;

  /// Trial package subtitle with price
  ///
  /// In en, this message translates to:
  /// **'Then {price}/month'**
  String paywallTrialSubtitle(String price);

  /// Badge on trial card
  ///
  /// In en, this message translates to:
  /// **'Free Trial'**
  String get paywallTrialBadge;

  /// Lifetime package card title
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get paywallLifetimeTitle;

  /// CTA button text for trial package
  ///
  /// In en, this message translates to:
  /// **'Start Free Trial'**
  String get paywallCtaTrial;

  /// CTA button text for lifetime package
  ///
  /// In en, this message translates to:
  /// **'Unlock Now'**
  String get paywallCtaLifetime;

  /// Restore purchases link in paywall
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get paywallRestore;

  /// Session section title in dev tools
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get devToolsSessionSection;

  /// Session count label in dev tools
  ///
  /// In en, this message translates to:
  /// **'Session Count'**
  String get devToolsSessionCount;

  /// Status message after updating session count
  ///
  /// In en, this message translates to:
  /// **'Session count set to {count}.'**
  String devToolsSessionCountUpdated(int count);

  /// Reset section title in dev tools
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get devToolsResetSection;

  /// Reset button label in dev tools
  ///
  /// In en, this message translates to:
  /// **'Reset to First Install State'**
  String get devToolsResetButton;

  /// Status message after successful reset
  ///
  /// In en, this message translates to:
  /// **'Reset complete.'**
  String get devToolsResetComplete;

  /// Error prefix in dev tools status
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get devToolsError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
