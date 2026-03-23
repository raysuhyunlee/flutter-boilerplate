// Flutter imports:
import 'package:flutter/material.dart';

class BlinkingAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double maxOpacity;
  final double minOpacity;

  const BlinkingAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.maxOpacity = 1.0,
    this.minOpacity = 0.0,
  });

  @override
  BlinkingAnimationState createState() => BlinkingAnimationState();
}

class BlinkingAnimationState extends State<BlinkingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _opacity =
        Tween<double>(begin: widget.minOpacity, end: widget.maxOpacity).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: widget.child,
    );
  }
}
