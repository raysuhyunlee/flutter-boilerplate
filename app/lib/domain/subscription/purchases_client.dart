import 'package:purchases_flutter/purchases_flutter.dart';

/// Abstraction over RevenueCat's static [Purchases] API.
///
/// Enables dependency injection and testability by decoupling
/// [SubscriptionRepository] from the concrete SDK calls.
abstract class PurchasesClient {
  Future<void> setLogLevel(LogLevel level);
  Future<void> configure(PurchasesConfiguration configuration);
  Future<CustomerInfo> getCustomerInfo();
  Future<CustomerInfo> restorePurchases();
  Future<Offerings> getOfferings();
  Future<CustomerInfo> purchasePackage(Package package);
  void addCustomerInfoUpdateListener(void Function(CustomerInfo) listener);
}

class RevenueCatPurchasesClient implements PurchasesClient {
  @override
  Future<void> setLogLevel(LogLevel level) =>
      Purchases.setLogLevel(level);

  @override
  Future<void> configure(PurchasesConfiguration configuration) =>
      Purchases.configure(configuration);

  @override
  Future<CustomerInfo> getCustomerInfo() =>
      Purchases.getCustomerInfo();

  @override
  Future<CustomerInfo> restorePurchases() =>
      Purchases.restorePurchases();

  @override
  Future<Offerings> getOfferings() =>
      Purchases.getOfferings();

  @override
  Future<CustomerInfo> purchasePackage(Package package) =>
      Purchases.purchasePackage(package);

  @override
  void addCustomerInfoUpdateListener(void Function(CustomerInfo) listener) =>
      Purchases.addCustomerInfoUpdateListener(listener);
}
