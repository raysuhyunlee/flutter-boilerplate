// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_boilerplate/app/resources/colors.dart';

final appTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.lightGray,
    onSecondary: Colors.black,
    error: AppColors.error,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  cardTheme: const CardThemeData(
    color: Colors.white,
  ),
);
