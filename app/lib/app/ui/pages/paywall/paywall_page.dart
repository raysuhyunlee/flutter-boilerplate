// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:flutter_boilerplate/app/extensions/build_context_extensions.dart';
import 'package:flutter_boilerplate/app/resources/colors.dart';
import 'package:flutter_boilerplate/app/resources/sizes.dart';
import 'package:flutter_boilerplate/app/resources/text_styles.dart';
import 'package:flutter_boilerplate/app/ui/widgets/common/cta_button.dart';
import 'package:flutter_boilerplate/domain/event/event_service.dart';
import 'package:flutter_boilerplate/domain/subscription/subscription_repository.dart';
import 'package:flutter_boilerplate/resources/app_config.dart';

/// A feature item shown in the paywall hero section.
class PaywallFeature {
  final String label;
  final IconData icon;

  const PaywallFeature({required this.label, required this.icon});
}

class PaywallPage extends StatefulWidget {
  final bool dismissible;

  /// Features to display. If null, uses default feature list.
  final List<PaywallFeature>? features;

  const PaywallPage({
    super.key,
    this.dismissible = true,
    this.features,
  });

  /// Returns true if device has internet connectivity.
  static Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  /// Show paywall as a full-screen page. Returns true if user purchased.
  /// Skips paywall when offline since purchases require internet.
  static Future<bool> show(
    BuildContext context, {
    bool dismissible = true,
    List<PaywallFeature>? features,
  }) async {
    if (!await _hasInternetConnection()) return false;

    final result = await Navigator.of(context, rootNavigator: true).push<bool>(
      MaterialPageRoute(
        builder: (_) => PaywallPage(
          dismissible: dismissible,
          features: features,
        ),
      ),
    );
    return result ?? false;
  }

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  final _subscriptionRepo = GetIt.instance<SubscriptionRepository>();
  final _eventService = GetIt.instance<EventService>();
  final _logger = GetIt.instance<Logger>();

  List<Package> _packages = [];
  bool _loading = true;
  bool _purchasing = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _eventService.publish(Events.paywallShow, parameters: {
      'trigger': widget.dismissible ? 'dismissible' : 'forced',
    });
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await _subscriptionRepo.getOfferings();
      final current = offerings?.current;
      if (current != null && mounted) {
        setState(() {
          _packages = current.availablePackages;
          _loading = false;
        });
      } else {
        if (mounted) setState(() => _loading = false);
      }
    } catch (e, st) {
      _logger.e('Failed to load offerings', error: e, stackTrace: st);
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _purchase(Package package) async {
    setState(() => _purchasing = true);
    try {
      final customerInfo = await _subscriptionRepo.purchasePackage(package);
      if (customerInfo == null) return;
      final isActive = customerInfo
              .entitlements.all[AppConfig.revenueCatEntitlementId]?.isActive ??
          false;
      if (mounted && isActive) {
        _eventService.publish(Events.paywallPurchase, parameters: {
          'package_type': package.packageType.name,
        });
        Navigator.pop(context, true);
      }
    } on PlatformException catch (e) {
      // code '1' = user cancelled
      if (e.code != '1') {
        _logger.e('Purchase failed', error: e);
      }
    } catch (e, st) {
      _logger.e('Purchase failed', error: e, stackTrace: st);
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _restore() async {
    setState(() => _purchasing = true);
    try {
      final customerInfo = await _subscriptionRepo.restorePurchases();
      if (customerInfo == null) return;
      final isActive = customerInfo
              .entitlements.all[AppConfig.revenueCatEntitlementId]?.isActive ??
          false;
      if (mounted && isActive) {
        Navigator.pop(context, true);
      }
    } catch (e, st) {
      _logger.e('Restore failed', error: e, stackTrace: st);
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  List<PaywallFeature> get _features =>
      widget.features ??
      [
        PaywallFeature(
            label: context.l10n.paywallFeature1, icon: Icons.star_rounded),
        PaywallFeature(
            label: context.l10n.paywallFeature2, icon: Icons.block_rounded),
        PaywallFeature(
            label: context.l10n.paywallFeature3,
            icon: Icons.all_inclusive_rounded),
      ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.dismissible,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _buildCloseRow(),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _buildHero(),
                          _buildFeatures(),
                          _buildPricing(),
                        ],
                      ),
                    ),
                    _buildCtaArea(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildCloseRow() {
    if (!widget.dismissible) {
      return const SizedBox(height: AppSizes.spacingBase);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spacingXl,
        AppSizes.spacingBase,
        AppSizes.spacingXl,
        0,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            _eventService.publish(Events.paywallClose);
            Navigator.pop(context, false);
          },
          child: const Icon(
            Icons.close,
            color: AppColors.textDisabled,
            size: AppSizes.iconLg,
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spacing2xl,
        AppSizes.spacingXl,
        AppSizes.spacing2xl,
        0,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.workspace_premium_rounded,
            size: 80,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSizes.spacingSm),
          Text(
            context.l10n.paywallTitle,
            style: AppTextStyles.heading1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spacing2xl,
        AppSizes.spacing2xl,
        AppSizes.spacing2xl,
        0,
      ),
      child: Column(
        children: _features.map((f) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spacingMd),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(f.icon, color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: AppSizes.spacingBase),
                Expanded(
                  child: Text(
                    f.label,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPricing() {
    if (_packages.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spacingXl,
        AppSizes.spacing2xl,
        AppSizes.spacingXl,
        0,
      ),
      child: Column(
        children: List.generate(_packages.length, (index) {
          final package = _packages[index];
          final isSelected = index == _selectedIndex;
          final isLifetime = package.packageType == PackageType.lifetime;

          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: isLifetime
                ? _buildLifetimeCard(package, isSelected)
                : _buildTrialCard(package, isSelected),
          );
        }),
      ),
    );
  }

  Widget _buildTrialCard(Package package, bool isSelected) {
    final price = package.storeProduct.priceString;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingMd),
      padding: const EdgeInsets.all(AppSizes.spacingLg),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF8FAFF) : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          _buildRadio(isSelected),
          const SizedBox(width: AppSizes.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.paywallTrialTitle,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.paywallTrialSubtitle(price),
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ),
          Text(
            context.l10n.paywallTrialBadge,
            style: AppTextStyles.heading4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLifetimeCard(Package package, bool isSelected) {
    final price = package.storeProduct.priceString;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingMd),
      padding: const EdgeInsets.all(AppSizes.spacingLg),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF8FAFF) : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          _buildRadio(isSelected),
          const SizedBox(width: AppSizes.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.paywallLifetimeTitle,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadio(bool isSelected) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.divider,
          width: isSelected ? 6 : 2,
        ),
      ),
    );
  }

  String get _ctaText {
    if (_packages.isEmpty) return '';
    final selected = _packages[_selectedIndex];
    return selected.packageType == PackageType.lifetime
        ? context.l10n.paywallCtaLifetime
        : context.l10n.paywallCtaTrial;
  }

  Widget _buildCtaArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spacingXl,
        0,
        AppSizes.spacingXl,
        MediaQuery.of(context).padding.bottom + AppSizes.spacing3xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CtaButton(
            text: _ctaText,
            loading: _purchasing,
            onPressed:
                _packages.isEmpty ? null : () => _purchase(_packages[_selectedIndex]),
          ),
          const SizedBox(height: AppSizes.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterLink(
                context.l10n.paywallRestore,
                _purchasing ? null : _restore,
              ),
              _buildFooterDivider(),
              _buildFooterLink(
                context.l10n.termsOfUse,
                () => launchUrl(Uri.parse(AppConfig.termsUrl)),
              ),
              _buildFooterDivider(),
              _buildFooterLink(
                context.l10n.privacyPolicy,
                () => launchUrl(Uri.parse(AppConfig.privacyPolicyUrl)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textDisabled,
          fontSize: AppSizes.textSm,
        ),
      ),
    );
  }

  Widget _buildFooterDivider() {
    return Text(
      '  |  ',
      style: AppTextStyles.labelSmall.copyWith(
        color: AppColors.textDisabled,
        fontSize: AppSizes.textSm,
      ),
    );
  }
}
