// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import 'package:daily_tasks/main.dart';
import 'package:daily_tasks/features/tasks/domain/entities/task.dart';
import 'package:daily_tasks/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:daily_tasks/features/tasks/domain/usecases/add_task.dart';
import 'package:daily_tasks/features/tasks/domain/usecases/delete_task.dart';
import 'package:daily_tasks/features/tasks/domain/usecases/get_tasks.dart';
import 'package:daily_tasks/features/tasks/domain/usecases/update_task.dart';
import 'package:daily_tasks/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:daily_tasks/core/notifications/domain/notifications_repository.dart';
import 'package:daily_tasks/core/notifications/usecases/cancel_task_reminder.dart';
import 'package:daily_tasks/core/notifications/usecases/upsert_task_reminder.dart';
import 'package:daily_tasks/features/settings/domain/entities/app_settings.dart';
import 'package:daily_tasks/features/settings/domain/repositories/settings_repository.dart';
import 'package:daily_tasks/features/settings/domain/usecases/get_settings.dart';
import 'package:daily_tasks/features/settings/domain/usecases/set_dark_mode.dart';
import 'package:daily_tasks/features/settings/domain/usecases/set_language_code.dart';
import 'package:daily_tasks/features/settings/presentation/cubit/settings_cubit.dart';

void main() {
  testWidgets('App shows Daily Tasks title', (WidgetTester tester) async {
    final repository = _InMemoryTasksRepository();
    final notificationsRepository = _NoopNotificationsRepository();
    final settingsRepository = _InMemorySettingsRepository();
    final cubit = TasksCubit(
      getTasks: GetTasks(repository),
      addTask: AddTask(repository),
      updateTask: UpdateTask(repository),
      deleteTask: DeleteTask(repository),
      upsertTaskReminder: UpsertTaskReminder(notificationsRepository),
      cancelTaskReminder: CancelTaskReminder(notificationsRepository),
    )..load();

    final settingsCubit = SettingsCubit(
      getSettings: GetSettings(settingsRepository),
      setDarkMode: SetDarkMode(settingsRepository),
      setLanguageCode: SetLanguageCode(settingsRepository),
    )..load();

    await tester.pumpWidget(
      AppRoot(tasksCubit: cubit, settingsCubit: settingsCubit),
    );
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text('Daily Tasks'), findsOneWidget);
  });
}

class _InMemoryTasksRepository implements TasksRepository {
  final List<Task> _tasks = [];

  @override
  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
  }

  @override
  Future<List<Task>> getTasks() async {
    return List<Task>.unmodifiable(_tasks);
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }
}

class _NoopNotificationsRepository implements NotificationsRepository {
  @override
  Future<void> cancel(int id) async {}

  @override
  Future<void> cancelAll() async {}

  @override
  String? formatDueAt(DateTime dueAt, {locale}) => null;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermissions() async => true;

  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String? payload,
    required Locale? locale,
  }) async {}
}

class _InMemorySettingsRepository implements SettingsRepository {
  AppSettings _settings = AppSettings.defaults;

  @override
  Future<AppSettings> getSettings() async => _settings;

  @override
  Future<void> setDarkMode(bool isDarkMode) async {
    _settings = _settings.copyWith(isDarkMode: isDarkMode);
  }

  @override
  Future<void> setLanguageCode(String languageCode) async {
    _settings = _settings.copyWith(languageCode: languageCode);
  }
}
