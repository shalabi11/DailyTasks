import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneInit {
  const TimezoneInit._();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    try {
      final localTz = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTz.identifier));
    } catch (_) {
      // Fall back to the default (often UTC) if timezone detection fails.
    }
  }
}
