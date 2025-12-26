import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_theme.dart';
import 'core/notifications/data/flutter_local_notifications_repository.dart';
import 'core/notifications/domain/notifications_repository.dart';
import 'core/notifications/timezone_init.dart';
import 'core/notifications/usecases/cancel_task_reminder.dart';
import 'core/notifications/usecases/upsert_task_reminder.dart';
import 'features/tasks/data/datasources/tasks_local_data_source.dart';
import 'features/tasks/data/models/task_hive_model.dart';
import 'features/tasks/data/repositories/tasks_repository_impl.dart';
import 'features/tasks/domain/usecases/add_task.dart';
import 'features/tasks/domain/usecases/delete_task.dart';
import 'features/tasks/domain/usecases/get_tasks.dart';
import 'features/tasks/domain/usecases/update_task.dart';
import 'features/tasks/presentation/cubit/tasks_cubit.dart';
import 'features/settings/data/datasources/settings_local_data_source.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/usecases/get_settings.dart';
import 'features/settings/domain/usecases/set_dark_mode.dart';
import 'features/settings/domain/usecases/set_language_code.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TimezoneInit.initialize();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(TaskHiveModelAdapter().typeId)) {
    Hive.registerAdapter(TaskHiveModelAdapter());
  }
  final tasksBox = await Hive.openBox<TaskHiveModel>('tasks');
  final settingsBox = await Hive.openBox('settings');

  final NotificationsRepository notificationsRepository =
      FlutterLocalNotificationsRepository(FlutterLocalNotificationsPlugin());
  await notificationsRepository.initialize();
  await notificationsRepository.requestPermissions();

  final localDataSource = TasksLocalDataSource(tasksBox);
  final repository = TasksRepositoryImpl(localDataSource);

  final settingsLocal = SettingsLocalDataSource(settingsBox);
  final settingsRepository = SettingsRepositoryImpl(settingsLocal);
  final getSettings = GetSettings(settingsRepository);
  final setDarkMode = SetDarkMode(settingsRepository);
  final setLanguageCode = SetLanguageCode(settingsRepository);

  final getTasks = GetTasks(repository);
  final addTask = AddTask(repository);
  final updateTask = UpdateTask(repository);
  final deleteTask = DeleteTask(repository);

  final upsertTaskReminder = UpsertTaskReminder(notificationsRepository);
  final cancelTaskReminder = CancelTaskReminder(notificationsRepository);

  runApp(
    AppRoot(
      tasksCubit: TasksCubit(
        getTasks: getTasks,
        addTask: addTask,
        updateTask: updateTask,
        deleteTask: deleteTask,
        upsertTaskReminder: upsertTaskReminder,
        cancelTaskReminder: cancelTaskReminder,
      )..load(),
      settingsCubit: SettingsCubit(
        getSettings: getSettings,
        setDarkMode: setDarkMode,
        setLanguageCode: setLanguageCode,
      )..load(),
    ),
  );
}

class AppRoot extends StatelessWidget {
  const AppRoot({
    super.key,
    required this.tasksCubit,
    required this.settingsCubit,
  });

  final TasksCubit tasksCubit;
  final SettingsCubit settingsCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: tasksCubit),
        BlocProvider.value(value: settingsCubit),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final settings = SettingsCubit.effective(state);
        final locale = Locale(settings.languageCode);

        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashPage(),
        );
      },
    );
  }
}
