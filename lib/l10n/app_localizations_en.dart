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
  String get categoryLabel => 'Category';

  @override
  String get priorityLabel => 'Priority';

  @override
  String get recurrenceLabel => 'Recurrence';

  @override
  String get categoryWork => 'Work';

  @override
  String get categoryPersonal => 'Personal';

  @override
  String get categoryUrgent => 'Urgent';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryOther => 'Other';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get recurrenceNone => 'None';

  @override
  String get recurrenceDaily => 'Daily';

  @override
  String get recurrenceWeekly => 'Weekly';

  @override
  String get recurrenceMonthly => 'Monthly';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterCompleted => 'Completed';

  @override
  String get statistics => 'Statistics';

  @override
  String get statsTitle => 'Task Statistics';

  @override
  String get statsTotal => 'Total Tasks';

  @override
  String get statsCompleted => 'Completed';

  @override
  String get statsActive => 'Active';

  @override
  String get statsCompletionRate => 'Completion Rate';

  @override
  String get statsByCategory => 'By Category';

  @override
  String get statsByPriority => 'By Priority';

  @override
  String get taskRemindersChannelName => 'Task reminders';

  @override
  String get taskRemindersChannelDescription =>
      'Reminder notifications for scheduled tasks';

  @override
  String get skip => 'Skip';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get introTitle1 => 'Welcome to Daily Tasks';

  @override
  String get introDescription1 =>
      'Organize your daily tasks efficiently with our beautiful and intuitive task manager. Stay productive and never miss a deadline.';

  @override
  String get introTitle2 => 'Organize with Categories';

  @override
  String get introDescription2 =>
      'Categorize your tasks by Work, Personal, Urgent, Shopping, Health, and more. Set priorities to focus on what matters most.';

  @override
  String get introTitle3 => 'Smart Reminders';

  @override
  String get introDescription3 =>
      'Never forget important tasks with customizable reminders. Get notified at the right time to stay on track.';

  @override
  String get introTitle4 => 'Ready to Start?';

  @override
  String get introDescription4 =>
      'Start managing your tasks effectively today. Track your progress with statistics and achieve your goals.';
}
