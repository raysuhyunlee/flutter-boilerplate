// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_boilerplate/app/resources/colors.dart';

class TidyInputDecoration extends InputDecoration {
  TidyInputDecoration({
    super.labelText,
    super.hintText,
    IconData? icon,
  }) : super(
          prefixIcon: icon != null ? Icon(icon) : null,
          border: const OutlineInputBorder(
              borderSide: BorderSide(),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.lightGray),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
        );
}
