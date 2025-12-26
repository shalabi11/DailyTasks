// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'المهام اليومية';

  @override
  String get dailyTasks => 'المهام اليومية';

  @override
  String get noTasksYet => 'لا توجد مهام بعد.';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get titleLabel => 'العنوان';

  @override
  String get dueDateLabel => 'تاريخ الاستحقاق';

  @override
  String get dueTimeLabel => 'وقت الاستحقاق';

  @override
  String get pick => 'اختيار';

  @override
  String get reminderLabel => 'تذكير';

  @override
  String get reminderOff => 'إيقاف';

  @override
  String reminderMinutesBefore(Object minutes) {
    return 'قبل $minutes دقيقة';
  }

  @override
  String reminderMinutesBeforeShort(Object minutes) {
    return 'قبل $minutesد';
  }

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get titleRequired => 'العنوان مطلوب.';

  @override
  String dueAt(Object when) {
    return 'الاستحقاق $when';
  }

  @override
  String get taskRemindersChannelName => 'تذكير المهام';

  @override
  String get taskRemindersChannelDescription => 'إشعارات تذكير للمهام المجدولة';
}
