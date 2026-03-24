// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get_it/get_it.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart' show Share;
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:flutter_boilerplate/app/extensions/build_context_extensions.dart';
import 'package:flutter_boilerplate/app/resources/colors.dart';
import 'package:flutter_boilerplate/app/resources/sizes.dart';
import 'package:flutter_boilerplate/app/resources/text_styles.dart';
import 'package:flutter_boilerplate/app/ui/pages/settings/dev_tools_page.dart';
import 'package:flutter_boilerplate/domain/event/event_service.dart';
import 'package:flutter_boilerplate/resources/app_config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _eventService = GetIt.instance<EventService>();
  final _logger = GetIt.instance<Logger>();

  int _devTapCount = 0;

  Future<void> _requestReview() async {
    _eventService.publish(Events.reviewApp);
    try {
      await InAppReview.instance.openStoreListing(
        appStoreId: AppConfig.appStoreId,
      );
    } catch (e, st) {
      _logger.e('Failed to open store listing', error: e, stackTrace: st);
    }
  }

  Future<void> _shareApp(BuildContext context) async {
    _eventService.publish(Events.shareApp);
    try {
      final storeUrl =
          Platform.isIOS ? AppConfig.appStoreUrl : AppConfig.playStoreUrl;
      final box = context.findRenderObject() as RenderBox?;
      final origin = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : Rect.zero;
      await Share.share(storeUrl, sharePositionOrigin: origin);
    } catch (e, st) {
      _logger.e('Failed to share app', error: e, stackTrace: st);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingXl,
            vertical: AppSizes.spacingBase,
          ),
          children: [
            const SizedBox(height: AppSizes.spacingSm),
            GestureDetector(
              onTap: () {
                _devTapCount++;
                if (_devTapCount >= 7) {
                  _devTapCount = 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DevToolsPage()),
                  );
                }
              },
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        const Icon(Icons.arrow_back_ios_new, size: 18),
                    color: AppColors.textTertiary,
                  ),
                  Text(context.l10n.settings,
                      style: AppTextStyles.heading3),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spacingLg),
            ...buildExtraSettingsSections(context),
            _buildSectionLabel(context.l10n.settingsOther),
            const SizedBox(height: AppSizes.spacingSm),
            _buildSettingsCard([
              _buildActionTile(
                icon: Icons.rate_review_outlined,
                iconColor: AppColors.purple,
                iconBgColor: AppColors.purpleSurface,
                title: context.l10n.settingsReview,
                onTap: _requestReview,
              ),
              const Divider(height: 1, indent: 52),
              Builder(builder: (tileContext) {
                return _buildActionTile(
                  icon: Icons.share_outlined,
                  iconColor: AppColors.purple,
                  iconBgColor: AppColors.purpleSurface,
                  title: context.l10n.settingsShare,
                  onTap: () => _shareApp(tileContext),
                );
              }),
              const Divider(height: 1, indent: 52),
              _buildActionTile(
                icon: Icons.description_outlined,
                iconColor: AppColors.textTertiary,
                iconBgColor: AppColors.surfaceSecondary,
                title: context.l10n.termsOfUse,
                onTap: () => launchUrl(Uri.parse(AppConfig.termsUrl)),
              ),
              const Divider(height: 1, indent: 52),
              _buildActionTile(
                icon: Icons.privacy_tip_outlined,
                iconColor: AppColors.textTertiary,
                iconBgColor: AppColors.surfaceSecondary,
                title: context.l10n.privacyPolicy,
                onTap: () =>
                    launchUrl(Uri.parse(AppConfig.privacyPolicyUrl)),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  /// Override in a subclass to insert app-specific settings sections
  /// before the "Other" section.
  List<Widget> buildExtraSettingsSections(BuildContext context) => [];

  // ── Shared building blocks ──

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSizes.spacingXs),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    final radius = BorderRadius.circular(AppSizes.radiusLg);
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: radius,
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingBase,
          vertical: AppSizes.spacingBase,
        ),
        child: Row(
          children: [
            _buildIconBox(icon, iconColor, iconBgColor),
            const SizedBox(width: AppSizes.spacingMd),
            Expanded(
              child: Text(title, style: AppTextStyles.labelBase),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textDisabled,
              size: AppSizes.iconMd,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox(IconData icon, Color iconColor, Color bgColor) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Icon(icon, color: iconColor, size: AppSizes.iconMd),
    );
  }
}
