import '../repositories/settings_repository.dart';

class SetLanguageCode {
  const SetLanguageCode(this._repository);

  final SettingsRepository _repository;

  Future<void> call(String languageCode) =>
      _repository.setLanguageCode(languageCode);
}
