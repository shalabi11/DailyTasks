import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';

/// Builds category dropdown items
List<DropdownMenuItem<TaskCategory>> buildCategoryItems(AppLocalizations l10n) {
  return [
    DropdownMenuItem(value: TaskCategory.work, child: Text(l10n.categoryWork)),
    DropdownMenuItem(
      value: TaskCategory.personal,
      child: Text(l10n.categoryPersonal),
    ),
    DropdownMenuItem(
      value: TaskCategory.urgent,
      child: Text(l10n.categoryUrgent),
    ),
    DropdownMenuItem(
      value: TaskCategory.shopping,
      child: Text(l10n.categoryShopping),
    ),
    DropdownMenuItem(
      value: TaskCategory.health,
      child: Text(l10n.categoryHealth),
    ),
    DropdownMenuItem(
      value: TaskCategory.other,
      child: Text(l10n.categoryOther),
    ),
  ];
}

/// Builds priority dropdown items
List<DropdownMenuItem<TaskPriority>> buildPriorityItems(AppLocalizations l10n) {
  return [
    DropdownMenuItem(value: TaskPriority.low, child: Text(l10n.priorityLow)),
    DropdownMenuItem(
      value: TaskPriority.medium,
      child: Text(l10n.priorityMedium),
    ),
    DropdownMenuItem(value: TaskPriority.high, child: Text(l10n.priorityHigh)),
  ];
}

/// Builds recurrence dropdown items
List<DropdownMenuItem<RecurrenceType>> buildRecurrenceItems(
  AppLocalizations l10n,
) {
  return [
    DropdownMenuItem(
      value: RecurrenceType.none,
      child: Text(l10n.recurrenceNone),
    ),
    DropdownMenuItem(
      value: RecurrenceType.daily,
      child: Text(l10n.recurrenceDaily),
    ),
    DropdownMenuItem(
      value: RecurrenceType.weekly,
      child: Text(l10n.recurrenceWeekly),
    ),
    DropdownMenuItem(
      value: RecurrenceType.monthly,
      child: Text(l10n.recurrenceMonthly),
    ),
  ];
}

/// Builds reminder dropdown items
List<DropdownMenuItem<int?>> buildReminderItems(AppLocalizations l10n) {
  return [
    DropdownMenuItem<int?>(value: null, child: Text(l10n.reminderOff)),
    DropdownMenuItem<int?>(
      value: 5,
      child: Text(l10n.reminderMinutesBefore(5)),
    ),
    DropdownMenuItem<int?>(
      value: 10,
      child: Text(l10n.reminderMinutesBefore(10)),
    ),
    DropdownMenuItem<int?>(
      value: 30,
      child: Text(l10n.reminderMinutesBefore(30)),
    ),
  ];
}
