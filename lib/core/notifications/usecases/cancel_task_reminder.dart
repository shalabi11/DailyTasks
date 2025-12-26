import '../../notifications/domain/notifications_repository.dart';

class CancelTaskReminder {
  const CancelTaskReminder(this._notifications);

  final NotificationsRepository _notifications;

  Future<void> call({required String taskId}) async {
    await _notifications.cancel(_notificationIdFor(taskId));
  }

  int _notificationIdFor(String taskId) {
    return taskId.hashCode & 0x7fffffff;
  }
}
