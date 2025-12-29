import 'package:equatable/equatable.dart';

enum TaskCategory { work, personal, urgent, shopping, health, other }

enum TaskPriority { low, medium, high }

enum RecurrenceType { none, daily, weekly, monthly }

class Task extends Equatable {
  const Task({
    required this.id,
    required this.title,
    required this.dueAt,
    required this.isCompleted,
    this.reminderOffsetMinutes,
    this.category = TaskCategory.other,
    this.priority = TaskPriority.medium,
    this.recurrence = RecurrenceType.none,
    this.completedAt,
  });

  final String id;
  final String title;
  final DateTime dueAt;
  final bool isCompleted;
  final int? reminderOffsetMinutes;
  final TaskCategory category;
  final TaskPriority priority;
  final RecurrenceType recurrence;
  final DateTime? completedAt;

  Task copyWith({
    String? id,
    String? title,
    DateTime? dueAt,
    bool? isCompleted,
    int? reminderOffsetMinutes,
    bool clearReminderOffsetMinutes = false,
    TaskCategory? category,
    TaskPriority? priority,
    RecurrenceType? recurrence,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      dueAt: dueAt ?? this.dueAt,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderOffsetMinutes: clearReminderOffsetMinutes
          ? null
          : (reminderOffsetMinutes ?? this.reminderOffsetMinutes),
      category: category ?? this.category,
      priority: priority ?? this.priority,
      recurrence: recurrence ?? this.recurrence,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    dueAt,
    isCompleted,
    reminderOffsetMinutes,
    category,
    priority,
    recurrence,
    completedAt,
  ];
}
