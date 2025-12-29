import 'package:flutter/material.dart';

class TimeSegment extends StatelessWidget {
  const TimeSegment({
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.onPrimary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 48,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
