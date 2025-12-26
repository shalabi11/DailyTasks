import '../repositories/settings_repository.dart';

class SetDarkMode {
  const SetDarkMode(this._repository);

  final SettingsRepository _repository;

  Future<void> call(bool isDarkMode) => _repository.setDarkMode(isDarkMode);
}
