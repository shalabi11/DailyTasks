import 'package:flutter/material.dart';

import '../../../domain/entities/task.dart';
import '../../../../../l10n/app_localizations.dart';

class RecurrenceBadge extends StatelessWidget {
  const RecurrenceBadge({required this.recurrence});

  final RecurrenceType recurrence;

  String _getRecurrenceName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (recurrence) {
      case RecurrenceType.none:
        return '';
      case RecurrenceType.daily:
        return l10n.recurrenceDaily;
      case RecurrenceType.weekly:
        return l10n.recurrenceWeekly;
      case RecurrenceType.monthly:
        return l10n.recurrenceMonthly;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.repeat_rounded,
            size: 10,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 3),
          Text(
            _getRecurrenceName(context),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
