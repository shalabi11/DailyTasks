import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task.dart';

/// Validates task title
bool validateTaskTitle(String title) {
  return title.trim().isNotEmpty;
}

/// Creates a task from form data
Task createTaskFromForm({
  required String title,
  required DateTime dueDate,
  required TimeOfDay dueTime,
  required TaskCategory category,
  required TaskPriority priority,
  required RecurrenceType recurrence,
  required int? reminderOffsetMinutes,
  required Task? existingTask,
}) {
  final dueAt = DateTime(
    dueDate.year,
    dueDate.month,
    dueDate.day,
    dueTime.hour,
    dueTime.minute,
  );

  return Task(
    id: existingTask?.id ?? const Uuid().v4(),
    title: title.trim(),
    dueAt: dueAt,
    isCompleted: existingTask?.isCompleted ?? false,
    reminderOffsetMinutes: reminderOffsetMinutes,
    category: category,
    priority: priority,
    recurrence: recurrence,
    completedAt: existingTask?.completedAt,
  );
}
