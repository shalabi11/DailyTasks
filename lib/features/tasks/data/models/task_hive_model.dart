import 'package:hive/hive.dart';

import '../../domain/entities/task.dart';

class TaskHiveModel {
  TaskHiveModel({
    required this.id,
    required this.title,
    required this.dueAtMillis,
    required this.isCompleted,
    required this.reminderOffsetMinutes,
  });

  final String id;
  final String title;
  final int dueAtMillis;
  final bool isCompleted;
  final int? reminderOffsetMinutes;

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      dueAt: DateTime.fromMillisecondsSinceEpoch(dueAtMillis),
      isCompleted: isCompleted,
      reminderOffsetMinutes: reminderOffsetMinutes,
    );
  }

  static TaskHiveModel fromEntity(Task task) {
    return TaskHiveModel(
      id: task.id,
      title: task.title,
      dueAtMillis: task.dueAt.millisecondsSinceEpoch,
      isCompleted: task.isCompleted,
      reminderOffsetMinutes: task.reminderOffsetMinutes,
    );
  }
}

class TaskHiveModelAdapter extends TypeAdapter<TaskHiveModel> {
  @override
  final int typeId = 1;

  @override
  TaskHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return TaskHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      dueAtMillis: (fields[2] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      isCompleted: (fields[3] as bool?) ?? false,
      reminderOffsetMinutes: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dueAtMillis)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.reminderOffsetMinutes);
  }
}
