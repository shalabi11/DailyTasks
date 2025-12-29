import 'package:flutter/material.dart';

PageRoute<T> fadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(opacity: fade, child: child);
    },
  );
}

PageRoute<T> fadeSlideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      final offset = Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      // Add scale for exit animation
      final scale = Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic),
      );

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: offset,
          child: ScaleTransition(scale: scale, child: child),
        ),
      );
    },
  );
}

PageRoute<T> zoomRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 450),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scale = Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack));

      final fade = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      );

      return FadeTransition(
        opacity: fade,
        child: ScaleTransition(scale: scale, child: child),
      );
    },
  );
}
