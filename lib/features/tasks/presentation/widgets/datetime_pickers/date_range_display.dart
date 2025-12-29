import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeDisplay extends StatelessWidget {
  const DateRangeDisplay({
    required this.label,
    required this.date,
    required this.locale,
    required this.colorScheme,
  });

  final String label;
  final DateTime? date;
  final String? locale;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onPrimary.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.onPrimary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            date != null
                ? DateFormat('MMM dd, yyyy', locale).format(date!)
                : 'Not selected',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
