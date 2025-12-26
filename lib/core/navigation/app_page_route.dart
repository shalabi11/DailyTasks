import 'package:flutter/material.dart';

PageRoute<T> fadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(opacity: fade, child: child);
    },
  );
}

PageRoute<T> fadeSlideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final offset = Tween<Offset>(
        begin: const Offset(0, 0.03),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: offset, child: child),
      );
    },
  );
}
