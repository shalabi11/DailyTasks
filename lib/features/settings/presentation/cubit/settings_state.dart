import 'package:equatable/equatable.dart';

import '../../domain/entities/app_settings.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded(this.settings);

  final AppSettings settings;

  @override
  List<Object?> get props => [settings];
}

class SettingsError extends SettingsState {
  const SettingsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
