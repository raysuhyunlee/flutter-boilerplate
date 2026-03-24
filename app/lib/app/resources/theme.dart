// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_boilerplate/app/resources/colors.dart';

final appTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.purple,
    onSecondary: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.white,
    onSurface: AppColors.textPrimary,
  ),
  scaffoldBackgroundColor: AppColors.white,
  cardTheme: const CardThemeData(
    color: AppColors.white,
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.border,
    thickness: 0.5,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
);
