import '../../domain/entities/task.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_local_data_source.dart';
import '../models/task_hive_model.dart';

class TasksRepositoryImpl implements TasksRepository {
  TasksRepositoryImpl(this._localDataSource);

  final TasksLocalDataSource _localDataSource;

  @override
  Future<void> addTask(Task task) async {
    await _localDataSource.upsertTask(TaskHiveModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id) async {
    await _localDataSource.deleteTask(id);
  }

  @override
  Future<List<Task>> getTasks() async {
    final models = await _localDataSource.getTasks();
    final tasks = models.map((m) => m.toEntity()).toList(growable: false);
    tasks.sort((a, b) => a.dueAt.compareTo(b.dueAt));
    return tasks;
  }

  @override
  Future<void> updateTask(Task task) async {
    await _localDataSource.upsertTask(TaskHiveModel.fromEntity(task));
  }
}
