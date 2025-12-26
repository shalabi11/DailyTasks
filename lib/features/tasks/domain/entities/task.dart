import 'package:equatable/equatable.dart';

class Task extends Equatable {
  const Task({
    required this.id,
    required this.title,
    required this.dueAt,
    required this.isCompleted,
    this.reminderOffsetMinutes,
  });

  final String id;
  final String title;
  final DateTime dueAt;
  final bool isCompleted;
  final int? reminderOffsetMinutes;

  Task copyWith({
    String? id,
    String? title,
    DateTime? dueAt,
    bool? isCompleted,
    int? reminderOffsetMinutes,
    bool clearReminderOffsetMinutes = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      dueAt: dueAt ?? this.dueAt,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderOffsetMinutes: clearReminderOffsetMinutes
          ? null
          : (reminderOffsetMinutes ?? this.reminderOffsetMinutes),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    dueAt,
    isCompleted,
    reminderOffsetMinutes,
  ];
}
