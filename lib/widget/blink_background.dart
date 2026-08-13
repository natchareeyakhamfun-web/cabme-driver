import 'package:flutter/material.dart';

class BlinkBackground extends StatefulWidget {
  final Widget child;
  final Color beginColor;
  final Color endColor;

  const BlinkBackground({
    super.key,
    required this.child,
    required this.beginColor,
    required this.endColor,
  });

  @override
  State<BlinkBackground> createState() => _BlinkBackgroundState();
}

class _BlinkBackgroundState extends State<BlinkBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: widget.beginColor,
      end: widget.endColor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      child: widget.child,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        );
      },
    );
  }
}
