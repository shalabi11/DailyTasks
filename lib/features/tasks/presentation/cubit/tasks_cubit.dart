import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/update_task.dart';
import '../../../../core/notifications/usecases/cancel_task_reminder.dart';
import '../../../../core/notifications/usecases/upsert_task_reminder.dart';
import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({
    required GetTasks getTasks,
    required AddTask addTask,
    required UpdateTask updateTask,
    required DeleteTask deleteTask,
    required UpsertTaskReminder upsertTaskReminder,
    required CancelTaskReminder cancelTaskReminder,
  }) : _getTasks = getTasks,
       _addTask = addTask,
       _updateTask = updateTask,
       _deleteTask = deleteTask,
       _upsertTaskReminder = upsertTaskReminder,
       _cancelTaskReminder = cancelTaskReminder,
       super(const TasksInitial());

  final GetTasks _getTasks;
  final AddTask _addTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;
  final UpsertTaskReminder _upsertTaskReminder;
  final CancelTaskReminder _cancelTaskReminder;

  Future<void> load() async {
    emit(const TasksLoading());
    try {
      final tasks = await _getTasks();
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> add(Task task) async {
    try {
      await _addTask(task);
      await _upsertTaskReminder(task: task, locale: null);
      await load();
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> update(Task task) async {
    try {
      await _updateTask(task);
      await _upsertTaskReminder(task: task, locale: null);
      await load();
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> toggleCompleted(Task task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await update(updated);
  }

  Future<void> delete(String id) async {
    try {
      await _deleteTask(id);
      await _cancelTaskReminder(taskId: id);
      await load();
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }
}
