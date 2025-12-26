import '../entities/app_settings.dart';

abstract interface class SettingsRepository {
  Future<AppSettings> getSettings();
  Future<void> setDarkMode(bool isDarkMode);
  Future<void> setLanguageCode(String languageCode);
}
