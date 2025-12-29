import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Formats a DateTime to a localized date string
String formatDate(DateTime date, {String? locale, String? format}) {
  final dateFormat = format != null
      ? DateFormat(format, locale)
      : DateFormat.yMMMMd(locale);
  return dateFormat.format(date);
}

/// Formats a DateTime to a localized time string
String formatTime(TimeOfDay time, {String? locale, bool is24Hour = false}) {
  final now = DateTime.now();
  final dateTime = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );
  final timeFormat = is24Hour ? DateFormat.Hm(locale) : DateFormat.jm(locale);
  return timeFormat.format(dateTime);
}

/// Formats a DateTime to a complete date and time string
String formatDateTime(DateTime dateTime, {String? locale, String? format}) {
  final dateTimeFormat = format != null
      ? DateFormat(format, locale)
      : DateFormat.yMd(locale).add_jm();
  return dateTimeFormat.format(dateTime);
}

/// Formats a date range
String formatDateRange(DateTime startDate, DateTime endDate, {String? locale}) {
  final start = DateFormat.MMMd(locale).format(startDate);
  final end = DateFormat.MMMd(locale).format(endDate);
  return '$start - $end';
}

/// Converts TimeOfDay to DateTime
DateTime timeOfDayToDateTime(TimeOfDay time, {DateTime? date}) {
  final baseDate = date ?? DateTime.now();
  return DateTime(
    baseDate.year,
    baseDate.month,
    baseDate.day,
    time.hour,
    time.minute,
  );
}

/// Converts DateTime to TimeOfDay
TimeOfDay dateTimeToTimeOfDay(DateTime dateTime) {
  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}

/// Combines a date and time into a single DateTime
DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

/// Gets the relative time string (e.g., "Today", "Tomorrow", "Yesterday")
String getRelativeDateString(DateTime date, {String? locale}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateOnly = DateTime(date.year, date.month, date.day);

  final difference = dateOnly.difference(today).inDays;

  if (difference == 0) {
    return 'Today';
  } else if (difference == 1) {
    return 'Tomorrow';
  } else if (difference == -1) {
    return 'Yesterday';
  } else if (difference > 1 && difference < 7) {
    return DateFormat.EEEE(locale).format(date);
  } else {
    return formatDate(date, locale: locale);
  }
}

/// Checks if a date is today
bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

/// Checks if a date is in the past
bool isPast(DateTime date) {
  final now = DateTime.now();
  return date.isBefore(DateTime(now.year, now.month, now.day));
}

/// Gets the start of day for a given date
DateTime startOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// Gets the end of day for a given date
DateTime endOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
}

/// Calculates the number of days between two dates
int daysBetween(DateTime start, DateTime end) {
  final startDate = DateTime(start.year, start.month, start.day);
  final endDate = DateTime(end.year, end.month, end.day);
  return endDate.difference(startDate).inDays;
}

/// Gets a list of dates in a range
List<DateTime> getDatesInRange(DateTime start, DateTime end) {
  final dates = <DateTime>[];
  var current = start;
  while (!current.isAfter(end)) {
    dates.add(current);
    current = current.add(const Duration(days: 1));
  }
  return dates;
}

/// Adds a duration to a time
TimeOfDay addDurationToTime(TimeOfDay time, Duration duration) {
  final dateTime = timeOfDayToDateTime(time);
  final newDateTime = dateTime.add(duration);
  return dateTimeToTimeOfDay(newDateTime);
}

/// Gets the time difference in minutes
int minutesBetween(TimeOfDay start, TimeOfDay end) {
  final startMinutes = start.hour * 60 + start.minute;
  final endMinutes = end.hour * 60 + end.minute;
  return endMinutes - startMinutes;
}

/// Formats duration to readable string
String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  } else {
    return '${minutes}m';
  }
}

/// Validates if end time is after start time
bool isValidTimeRange(TimeOfDay start, TimeOfDay end) {
  final startMinutes = start.hour * 60 + start.minute;
  final endMinutes = end.hour * 60 + end.minute;
  return endMinutes > startMinutes;
}
