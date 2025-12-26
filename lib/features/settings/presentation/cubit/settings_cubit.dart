import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/set_dark_mode.dart';
import '../../domain/usecases/set_language_code.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required GetSettings getSettings,
    required SetDarkMode setDarkMode,
    required SetLanguageCode setLanguageCode,
  }) : _getSettings = getSettings,
       _setDarkMode = setDarkMode,
       _setLanguageCode = setLanguageCode,
       super(const SettingsLoading());

  final GetSettings _getSettings;
  final SetDarkMode _setDarkMode;
  final SetLanguageCode _setLanguageCode;

  Future<void> load() async {
    emit(const SettingsLoading());
    try {
      final settings = await _getSettings();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final updated = current.settings.copyWith(isDarkMode: value);
    emit(SettingsLoaded(updated));

    try {
      await _setDarkMode(value);
    } catch (e) {
      emit(SettingsError(e.toString()));
      await load();
    }
  }

  Future<void> setLanguage(String languageCode) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final updated = current.settings.copyWith(languageCode: languageCode);
    emit(SettingsLoaded(updated));

    try {
      await _setLanguageCode(languageCode);
    } catch (e) {
      emit(SettingsError(e.toString()));
      await load();
    }
  }

  static AppSettings effective(SettingsState state) {
    if (state is SettingsLoaded) return state.settings;
    return AppSettings.defaults;
  }
}
