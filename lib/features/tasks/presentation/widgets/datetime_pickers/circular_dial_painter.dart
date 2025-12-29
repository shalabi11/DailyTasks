import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Circular dial for time selection
class CircularDial extends CustomPainter {
  CircularDial({
    required this.selectedValue,
    required this.maxValue,
    required this.color,
    required this.isHourMode,
  });

  final int selectedValue;
  final int maxValue;
  final Color color;
  final bool isHourMode;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 30;

    // Draw circle outline
    final outlinePaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, outlinePaint);

    // Draw selection indicator line
    final angle = (math.pi * 2 * selectedValue) / (isHourMode ? 24 : 60) -
        math.pi / 2;
    final lineEnd = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(center, lineEnd, linePaint);

    // Draw center dot
    final centerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 6, centerPaint);
  }

  @override
  bool shouldRepaint(CircularDial oldDelegate) =>
      selectedValue != oldDelegate.selectedValue ||
      isHourMode != oldDelegate.isHourMode;
}
