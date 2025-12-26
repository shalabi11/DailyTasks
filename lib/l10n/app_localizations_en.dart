// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Daily Tasks';

  @override
  String get dailyTasks => 'Daily Tasks';

  @override
  String get noTasksYet => 'No tasks yet.';

  @override
  String get addTask => 'Add Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get settings => 'Settings';

  @override
  String get titleLabel => 'Title';

  @override
  String get dueDateLabel => 'Due date';

  @override
  String get dueTimeLabel => 'Due time';

  @override
  String get pick => 'Pick';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get reminderOff => 'Off';

  @override
  String reminderMinutesBefore(Object minutes) {
    return '$minutes minutes before';
  }

  @override
  String reminderMinutesBeforeShort(Object minutes) {
    return '${minutes}m before';
  }

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get titleRequired => 'Title is required.';

  @override
  String dueAt(Object when) {
    return 'Due $when';
  }

  @override
  String get taskRemindersChannelName => 'Task reminders';

  @override
  String get taskRemindersChannelDescription =>
      'Reminder notifications for scheduled tasks';
}
