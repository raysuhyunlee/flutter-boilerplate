// Flutter imports:
import 'package:flutter/material.dart';

class FlexibleDialog extends StatelessWidget {
  final ShapeBorder? shape;
  final AlignmentGeometry? alignment;
  final Widget child;

  final defaultShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  );
  final defaultAlignment = Alignment.center;

  const FlexibleDialog({
    super.key,
    this.shape,
    this.alignment,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? defaultAlignment,
      child: Card(
        shape: shape ?? defaultShape,
        child: child,
      ),
    );
  }
}
