import 'package:flutter/material.dart';

/// Animated button widget for form actions
class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.isPrimary,
  });

  final VoidCallback onPressed;
  final String label;
  final bool isPrimary;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.isPrimary
            ? FilledButton(
                onPressed: widget.onPressed,
                child: Text(widget.label),
              )
            : OutlinedButton(
                onPressed: widget.onPressed,
                child: Text(widget.label),
              ),
      ),
    );
  }
}
