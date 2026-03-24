class AppConfig {
  AppConfig();

  factory AppConfig.fromEnv(Map<String, String> env) {
    return AppConfig();
  }

  // TODO: Replace with your actual store IDs
  static const appStoreId = '';
  static const playStoreId = '';

  static const appStoreUrl = 'https://apps.apple.com/app/id$appStoreId';
  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=$playStoreId';

  // TODO: Replace with your actual URLs
  static const termsUrl = '';
  static const privacyPolicyUrl = '';

  // TODO: Replace with your RevenueCat API key
  static const revenueCatApiKey = '';
  static const revenueCatEntitlementId = 'pro';
}
