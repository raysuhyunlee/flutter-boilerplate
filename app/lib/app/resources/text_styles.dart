// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_boilerplate/app/resources/colors.dart';
import 'package:flutter_boilerplate/app/resources/sizes.dart';

class AppTextStyles {
  static const _baseStyle = TextStyle(
    color: AppColors.textPrimary,
  );

  // Headings
  static final heading1 = _baseStyle.copyWith(
    fontSize: AppSizes.text4xl,
    fontWeight: FontWeight.w800,
    height: 1.3,
  );

  static final heading2 = _baseStyle.copyWith(
    fontSize: AppSizes.text3xl,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static final heading3 = _baseStyle.copyWith(
    fontSize: AppSizes.text2xl,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static final heading4 = _baseStyle.copyWith(
    fontSize: AppSizes.textXl,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  // Body
  static final bodyLarge = _baseStyle.copyWith(
    fontSize: AppSizes.textLg,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static final bodyBase = _baseStyle.copyWith(
    fontSize: AppSizes.textBase,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static final bodySmall = _baseStyle.copyWith(
    fontSize: AppSizes.textSm,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textTertiary,
  );

  // Labels
  static final labelLarge = _baseStyle.copyWith(
    fontSize: AppSizes.textMd,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static final labelBase = _baseStyle.copyWith(
    fontSize: AppSizes.textBase,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static final labelSmall = _baseStyle.copyWith(
    fontSize: AppSizes.textSm,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textTertiary,
  );

  // Caption
  static final caption = _baseStyle.copyWith(
    fontSize: AppSizes.textXs,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: AppColors.textDisabled,
  );

  // Button
  static final button = _baseStyle.copyWith(
    fontSize: AppSizes.textLg,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
}
