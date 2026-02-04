// Flutter imports:
import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  final String message;

  const ErrorIndicator({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error),
      Text(message, textAlign: TextAlign.center),
    ]);
  }
}
