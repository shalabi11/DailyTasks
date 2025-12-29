import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../features/tasks/domain/entities/task.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/notifications_repository.dart';

class UpsertTaskReminder {
  const UpsertTaskReminder(this._notifications);

  final NotificationsRepository _notifications;

  Future<void> call({required Task task, required Locale? locale}) async {
    try {
      final notificationId = _notificationIdFor(task.id);

      if (kDebugMode) {
        debugPrint(
          'UpsertTaskReminder: Upserting reminder for task ${task.id}',
        );
        debugPrint('  Title: ${task.title}');
        debugPrint('  Due: ${task.dueAt}');
        debugPrint('  Completed: ${task.isCompleted}');
        debugPrint('  Reminder offset: ${task.reminderOffsetMinutes} minutes');
      }

      // Cancel any existing notification for this task
      await _notifications.cancel(notificationId);

      // Don't schedule reminders for completed tasks
      if (task.isCompleted) {
        if (kDebugMode) {
          debugPrint('  Skipping reminder (task is completed)');
        }
        return;
      }

      // Don't schedule if no reminder offset is set
      final offsetMinutes = task.reminderOffsetMinutes;
      if (offsetMinutes == null) {
        if (kDebugMode) {
          debugPrint('  Skipping reminder (no reminder offset set)');
        }
        return;
      }

      // Calculate the scheduled time
      final scheduledAt = task.dueAt.subtract(Duration(minutes: offsetMinutes));

      // Don't schedule notifications in the past
      if (!scheduledAt.isAfter(DateTime.now())) {
        if (kDebugMode) {
          debugPrint('  Skipping reminder (scheduled time is in the past)');
          debugPrint('  Scheduled: $scheduledAt, Now: ${DateTime.now()}');
        }
        return;
      }

      // Format the due time for display
      final when =
          _notifications.formatDueAt(task.dueAt, locale: locale) ??
          task.dueAt.toIso8601String();

      // Get localized strings
      final l10n = lookupAppLocalizations(locale ?? const Locale('en'));

      if (kDebugMode) {
        debugPrint('  Scheduling reminder at $scheduledAt');
        debugPrint('  Notification ID: $notificationId');
      }

      // Schedule the notification
      await _notifications.scheduleNotification(
        id: notificationId,
        title: task.title,
        body: l10n.dueAt(when),
        scheduledAt: scheduledAt,
        payload: task.id,
        locale: locale,
      );

      if (kDebugMode) {
        debugPrint('  Reminder scheduled successfully!');
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Error in UpsertTaskReminder: $e');
        debugPrintStack(stackTrace: st);
      }
      rethrow;
    }
  }

  int _notificationIdFor(String taskId) {
    return taskId.hashCode & 0x7fffffff;
  }
}
