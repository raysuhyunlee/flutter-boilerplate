// Flutter imports:
import 'package:flutter/material.dart';

class SimpleTextField extends TextField {
  SimpleTextField({
    super.key,
    super.controller,
    super.style,
    String? hintText,
    super.maxLines,
    super.minLines,
    super.autofocus,
  }) : super(
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            isDense: true,
          ),
        );
}
