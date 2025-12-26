import 'package:hive/hive.dart';

import '../models/task_hive_model.dart';

class TasksLocalDataSource {
  TasksLocalDataSource(this._box);

  final Box<TaskHiveModel> _box;

  Future<List<TaskHiveModel>> getTasks() async {
    return _box.values.toList(growable: false);
  }

  Future<void> upsertTask(TaskHiveModel task) async {
    await _box.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }
}
