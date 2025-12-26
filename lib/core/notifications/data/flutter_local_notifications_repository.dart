import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/notifications_repository.dart';
import '../../../l10n/app_localizations.dart';

class FlutterLocalNotificationsRepository implements NotificationsRepository {
  FlutterLocalNotificationsRepository(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  var _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  @override
  Future<bool> requestPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    var ok = true;

    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      ok = ok && (granted ?? true);
    }

    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      ok = ok && (granted ?? true);
    }

    return ok;
  }

  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String? payload,
    required Locale? locale,
  }) async {
    await initialize();

    final l10n = lookupAppLocalizations(locale ?? const Locale('en'));

    final androidDetails = AndroidNotificationDetails(
      'tasks_reminders',
      l10n.taskRemindersChannelName,
      channelDescription: l10n.taskRemindersChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tzDateTime = tz.TZDateTime.from(scheduledAt, tz.local);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
  }

  @override
  Future<void> cancel(int id) async {
    await initialize();
    await _plugin.cancel(id);
  }

  @override
  Future<void> cancelAll() async {
    await initialize();
    await _plugin.cancelAll();
  }

  @override
  String? formatDueAt(DateTime dueAt, {Locale? locale}) {
    final formatter = DateFormat.yMMMd(locale?.toLanguageTag()).add_jm();
    return formatter.format(dueAt);
  }
}
