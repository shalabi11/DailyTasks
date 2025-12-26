import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._local);

  final SettingsLocalDataSource _local;

  @override
  Future<AppSettings> getSettings() => _local.getSettings();

  @override
  Future<void> setDarkMode(bool isDarkMode) => _local.setDarkMode(isDarkMode);

  @override
  Future<void> setLanguageCode(String languageCode) =>
      _local.setLanguageCode(languageCode);
}
