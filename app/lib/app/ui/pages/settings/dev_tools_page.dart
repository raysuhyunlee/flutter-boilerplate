// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:flutter_boilerplate/app/app_reset_notifier.dart';
import 'package:flutter_boilerplate/app/extensions/build_context_extensions.dart';
import 'package:flutter_boilerplate/app/resources/colors.dart';
import 'package:flutter_boilerplate/app/resources/sizes.dart';
import 'package:flutter_boilerplate/app/resources/text_styles.dart';
import 'package:flutter_boilerplate/domain/session/session_service.dart';

/// Developer-only tools page, accessible via 7-tap easter egg on the
/// settings title. Override [buildSections] to add app-specific sections.
class DevToolsPage extends StatefulWidget {
  const DevToolsPage({super.key});

  @override
  State<DevToolsPage> createState() => _DevToolsPageState();
}

class _DevToolsPageState extends State<DevToolsPage> {
  final _sessionService = GetIt.instance<SessionService>();
  final _resetNotifier = GetIt.instance<AppResetNotifier>();
  final _logger = GetIt.instance<Logger>();
  String _status = '';
  int _sessionCount = 0;

  @override
  void initState() {
    super.initState();
    _loadSessionCount();
  }

  Future<void> _loadSessionCount() async {
    try {
      final count = await _sessionService.getCount();
      if (!mounted) return;
      setState(() => _sessionCount = count);
    } catch (e, st) {
      _logger.e('Failed to load session count', error: e, stackTrace: st);
    }
  }

  Future<void> _updateSessionCount(String value) async {
    try {
      final count = int.tryParse(value);
      if (count == null || count < 0) return;
      await _sessionService.setCount(count);
      await _loadSessionCount();
      if (!mounted) return;
      setState(
          () => _status = context.l10n.devToolsSessionCountUpdated(count));
    } catch (e, st) {
      _logger.e('Failed to update session count', error: e, stackTrace: st);
    }
  }

  Future<void> _resetSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _resetNotifier.reset();
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e, st) {
      _logger.e('Failed to reset session', error: e, stackTrace: st);
      if (!mounted) return;
      setState(() => _status = '${context.l10n.devToolsError}: $e');
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
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  color: AppColors.textTertiary,
                ),
                Text('Dev Tools', style: AppTextStyles.heading3),
              ],
            ),
            const SizedBox(height: AppSizes.spacingXl),
            _buildSection(context.l10n.devToolsSessionSection, [
              _buildSessionCountEditor(),
            ]),
            const SizedBox(height: AppSizes.spacingLg),
            _buildSection(context.l10n.devToolsResetSection, [
              _buildButton(
                  context.l10n.devToolsResetButton, _resetSession),
            ]),
            ...buildExtraSections(context),
            if (_status.isNotEmpty) ...[
              const SizedBox(height: AppSizes.spacingXl),
              Container(
                padding: const EdgeInsets.all(AppSizes.spacingBase),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Text(
                  _status,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Override this in a subclass to add app-specific dev tool sections.
  List<Widget> buildExtraSections(BuildContext context) => [];

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: AppSizes.spacingSm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Column(
            children: List.generate(children.length * 2 - 1, (i) {
              if (i.isOdd) return const Divider(height: 1, indent: 16);
              return children[i ~/ 2];
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionCountEditor() {
    final controller = TextEditingController(text: '$_sessionCount');
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingBase,
        vertical: AppSizes.spacingSm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(context.l10n.devToolsSessionCount,
                style: AppTextStyles.labelBase),
          ),
          SizedBox(
            width: 64,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelBase,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingSm,
                  vertical: AppSizes.spacingSm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
              onSubmitted: _updateSessionCount,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingBase,
          vertical: AppSizes.spacingBase,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: AppTextStyles.labelBase),
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
}
