// Flutter imports:
import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final Widget? child;
  final bool isLoading;
  final void Function()? onPressed;
  final ButtonStyle? style;

  const LoadingButton(
      {super.key,
      required this.child,
      required this.isLoading,
      required this.onPressed,
      this.style});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: isLoading
          ? const SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ))
          : child,
    );
  }
}
