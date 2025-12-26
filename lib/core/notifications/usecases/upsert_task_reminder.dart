import 'package:flutter/widgets.dart';

import '../../../features/tasks/domain/entities/task.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/notifications_repository.dart';

class UpsertTaskReminder {
  const UpsertTaskReminder(this._notifications);

  final NotificationsRepository _notifications;

  Future<void> call({required Task task, required Locale? locale}) async {
    final notificationId = _notificationIdFor(task.id);

    await _notifications.cancel(notificationId);

    if (task.isCompleted) return;

    final offsetMinutes = task.reminderOffsetMinutes;
    if (offsetMinutes == null) return;

    final scheduledAt = task.dueAt.subtract(Duration(minutes: offsetMinutes));
    if (!scheduledAt.isAfter(DateTime.now())) return;

    final when =
        _notifications.formatDueAt(task.dueAt, locale: locale) ??
        task.dueAt.toIso8601String();

    final l10n = lookupAppLocalizations(locale ?? const Locale('en'));

    await _notifications.scheduleNotification(
      id: notificationId,
      title: task.title,
      body: l10n.dueAt(when),
      scheduledAt: scheduledAt,
      payload: task.id,
      locale: locale,
    );
  }

  int _notificationIdFor(String taskId) {
    return taskId.hashCode & 0x7fffffff;
  }
}
