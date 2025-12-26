import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class UpdateTask {
  const UpdateTask(this._repository);

  final TasksRepository _repository;

  Future<void> call(Task task) => _repository.updateTask(task);
}
