import 'package:hive/hive.dart';

import '../../domain/entities/app_settings.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource(this._box);

  final Box _box;

  static const _darkModeKey = 'darkMode';
  static const _languageCodeKey = 'languageCode';

  Future<AppSettings> getSettings() async {
    final isDarkMode =
        _box.get(_darkModeKey, defaultValue: AppSettings.defaults.isDarkMode)
            as bool;
    final languageCode =
        _box.get(
              _languageCodeKey,
              defaultValue: AppSettings.defaults.languageCode,
            )
            as String;

    return AppSettings(isDarkMode: isDarkMode, languageCode: languageCode);
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    await _box.put(_darkModeKey, isDarkMode);
  }

  Future<void> setLanguageCode(String languageCode) async {
    await _box.put(_languageCodeKey, languageCode);
  }
}
