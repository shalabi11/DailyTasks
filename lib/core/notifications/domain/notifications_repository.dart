import 'package:flutter/material.dart';

abstract interface class NotificationsRepository {
  Future<void> initialize();

  Future<bool> requestPermissions();

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String? payload,
    required Locale? locale,
  });

  Future<void> cancel(int id);

  Future<void> cancelAll();

  String? formatDueAt(DateTime dueAt, {Locale? locale});
}
