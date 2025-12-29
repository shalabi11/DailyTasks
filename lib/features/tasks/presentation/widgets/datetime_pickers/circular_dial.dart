import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'clock_face_painter.dart';

class CircularDial extends StatefulWidget {
  const CircularDial({
    required this.selectedValue,
    required this.maxValue,
    required this.onValueSelected,
    required this.isHourMode,
  });

  final int selectedValue;
  final int maxValue;
  final Function(int) onValueSelected;
  final bool isHourMode;

  @override
  State<CircularDial> createState() => _CircularDialState();
}

class _CircularDialState extends State<CircularDial> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = 280.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Clock face
          CustomPaint(
            size: Size(size, size),
            painter: ClockFacePainter(
              selectedValue: widget.selectedValue,
              maxValue: widget.maxValue,
              color: colorScheme.primary,
              isHourMode: widget.isHourMode,
            ),
          ),
          // Numbers
          ...List.generate(widget.isHourMode ? 24 : 12, (index) {
            final value = widget.isHourMode ? index : index * 5;
            final angle =
                (math.pi * 2 * value) / (widget.isHourMode ? 24 : 60) -
                math.pi / 2;
            final radius = size / 2 - 30;
            final x = size / 2 + radius * math.cos(angle);
            final y = size / 2 + radius * math.sin(angle);

            final isSelected = value == widget.selectedValue;

            return Positioned(
              left: x - 20,
              top: y - 20,
              child: GestureDetector(
                onTap: () => widget.onValueSelected(value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : theme.textTheme.bodyLarge?.color,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: isSelected ? 16 : 14,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
