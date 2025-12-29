import 'package:flutter/foundation.dart';
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

    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        defaultPresentAlert: true,
        defaultPresentSound: true,
        defaultPresentBadge: true,
      );
      
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final success = await _plugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _handleNotificationResponse,
      );
      
      if (kDebugMode) {
        debugPrint('Notifications initialized successfully: $success');
      }
      
      _initialized = true;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Error initializing notifications: $e');
        debugPrintStack(stackTrace: st);
      }
      rethrow;
    }
  }

  void _handleNotificationResponse(NotificationResponse response) {
    if (kDebugMode) {
      debugPrint('Notification tapped with payload: ${response.payload}');
    }
  }

  @override
  Future<bool> requestPermissions() async {
    try {
      await initialize();
      
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      var allGranted = true;

      if (android != null) {
        try {
          final notificationsGranted = 
              await android.requestNotificationsPermission();
          if (kDebugMode) {
            debugPrint('Android notifications permission: $notificationsGranted');
          }
          allGranted = allGranted && (notificationsGranted ?? false);

          final exactAlarmsGranted = 
              await android.requestExactAlarmsPermission();
          if (kDebugMode) {
            debugPrint('Android exact alarms permission: $exactAlarmsGranted');
          }
          allGranted = allGranted && (exactAlarmsGranted ?? false);
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Error requesting Android permissions: $e');
          }
          allGranted = false;
        }
      }

      if (ios != null) {
        try {
          final granted = await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
          );
          if (kDebugMode) {
            debugPrint('iOS permissions: $granted');
          }
          allGranted = allGranted && (granted ?? false);
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Error requesting iOS permissions: $e');
          }
          allGranted = false;
        }
      }

      if (kDebugMode) {
        debugPrint('All permissions granted: $allGranted');
      }
      
      return allGranted;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Error in requestPermissions: $e');
        debugPrintStack(stackTrace: st);
      }
      return false;
    }
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
    try {
      await initialize();

      final l10n = lookupAppLocalizations(locale ?? const Locale('en'));

      // Android notification details with sensible defaults
      final androidDetails = AndroidNotificationDetails(
        'tasks_reminders',
        l10n.taskRemindersChannelName,
        channelDescription: l10n.taskRemindersChannelDescription,
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true,
        playSound: true,
        ongoing: false,
        autoCancel: true,
      );

      // iOS notification details with all permissions enabled
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
        threadIdentifier: 'tasks_reminders',
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final tzDateTime = tz.TZDateTime.from(scheduledAt, tz.local);

      if (kDebugMode) {
        debugPrint('Scheduling notification $id at $tzDateTime');
        debugPrint('Title: $title, Body: $body');
      }

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
      
      if (kDebugMode) {
        debugPrint('Notification $id scheduled successfully');
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Error scheduling notification: $e');
        debugPrintStack(stackTrace: st);
      }
      rethrow;
    }
  }

  @override
  Future<void> cancel(int id) async {
    try {
      await initialize();
      await _plugin.cancel(id);
      if (kDebugMode) {
        debugPrint('Cancelled notification $id');
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Error cancelling notification $id: $e');
        debugPrintStack(stackTrace: st);
      }
    }
  }

  @override
  Future<void> cancelAll() async {
    try {
      await initialize();
      await _plugin.cancelAll();
      if (kDebugMode) {
        debugPrint('Cancelled all notifications');
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Error cancelling all notifications: $e');
        debugPrintStack(stackTrace: st);
      }
    }
  }

  @override
  String? formatDueAt(DateTime dueAt, {Locale? locale}) {
    final formatter = DateFormat.yMMMd(locale?.toLanguageTag()).add_jm();
    return formatter.format(dueAt);
  }
}
