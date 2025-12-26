import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class AddTask {
  const AddTask(this._repository);

  final TasksRepository _repository;

  Future<void> call(Task task) => _repository.addTask(task);
}
