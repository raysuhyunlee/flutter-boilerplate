// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_boilerplate/app/extensions/build_context_extensions.dart';
import 'package:flutter_boilerplate/app/resources/colors.dart';
import 'package:flutter_boilerplate/app/resources/sizes.dart';
import 'package:flutter_boilerplate/app/resources/text_styles.dart';
import 'package:flutter_boilerplate/app/ui/widgets/common/cta_button.dart';

/// A single step in the onboarding flow.
class OnboardingStep {
  /// Widget shown in the top area (image, animation, custom widget, etc.).
  final Widget visual;
  final String title;
  final String description;

  const OnboardingStep({
    required this.visual,
    required this.title,
    required this.description,
  });
}

/// Generic onboarding page with swipeable steps, page indicators,
/// and an optional notification permission request on the last step.
///
/// Supply your own [steps] to customise the content.
/// The last step shows [lastStepCtaText] and calls [onRequestPermission]
/// before completing; earlier steps show a "Next" button.
class OnboardingPage extends StatefulWidget {
  final List<OnboardingStep> steps;
  final VoidCallback onComplete;

  /// Called on the last step's CTA. If null, the last step simply completes.
  final Future<void> Function()? onRequestPermission;

  /// CTA label for the last step. Defaults to l10n.onboardingAllowNotifications.
  final String? lastStepCtaText;

  /// Skip label for the last step. Defaults to l10n.onboardingSkipNotifications.
  final String? lastStepSkipText;

  const OnboardingPage({
    super.key,
    required this.steps,
    required this.onComplete,
    this.onRequestPermission,
    this.lastStepCtaText,
    this.lastStepSkipText,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;
  bool _loading = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    _pageController.animateToPage(
      _currentPage + 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onLastStepPressed() async {
    if (widget.onRequestPermission != null) {
      setState(() => _loading = true);
      try {
        await widget.onRequestPermission!();
      } finally {
        if (mounted) widget.onComplete();
      }
    } else {
      widget.onComplete();
    }
  }

  void _onSkip() {
    widget.onComplete();
  }

  bool get _isLastPage => _currentPage == widget.steps.length - 1;
  bool get _hasPermissionStep => widget.onRequestPermission != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.steps.length,
              onPageChanged: (index) =>
                  setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final step = widget.steps[index];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).padding.top),
                      step.visual,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSizes.spacingXl,
                          AppSizes.spacing2xl,
                          AppSizes.spacingXl,
                          0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: AppTextStyles.heading2.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: AppSizes.spacingMd),
                            Text(
                              step.description,
                              style: AppTextStyles.labelLarge.copyWith(
                                fontWeight: FontWeight.normal,
                                color: AppColors.textTertiary,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spacingXl,
              0,
              AppSizes.spacingXl,
              0,
            ),
            child: Column(
              children: [
                if (!_isLastPage) _buildIndicators(),
                if (!_isLastPage)
                  const SizedBox(height: AppSizes.spacingXl),
                CtaButton(
                  text: _isLastPage && _hasPermissionStep
                      ? (widget.lastStepCtaText ??
                          context.l10n.onboardingAllowNotifications)
                      : _isLastPage
                          ? context.l10n.onboardingStart
                          : context.l10n.onboardingNext,
                  loading: _loading,
                  onPressed:
                      _isLastPage ? _onLastStepPressed : _onNextPressed,
                ),
                if (_isLastPage && _hasPermissionStep)
                  GestureDetector(
                    onTap: _onSkip,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: AppSizes.spacingMd),
                      child: Text(
                        widget.lastStepSkipText ??
                            context.l10n.onboardingSkipNotifications,
                        style: AppTextStyles.labelBase.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 22),
              ],
            ),
          ),
          SizedBox(
            height:
                MediaQuery.of(context).padding.bottom + AppSizes.spacingSm,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.steps.length, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.only(
            right:
                index < widget.steps.length - 1 ? AppSizes.spacingSm : 0,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == _currentPage
                ? AppColors.primary
                : AppColors.divider,
          ),
        );
      }),
    );
  }
}
