import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  const AppSettings({required this.isDarkMode, required this.languageCode});

  final bool isDarkMode;

  /// ISO 639-1 language code: "en" or "ar".
  final String languageCode;

  AppSettings copyWith({bool? isDarkMode, String? languageCode}) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, languageCode];

  static const defaults = AppSettings(isDarkMode: false, languageCode: 'en');
}
