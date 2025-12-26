import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final settings = SettingsCubit.effective(state);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile(
                value: settings.isDarkMode,
                onChanged: (v) =>
                    context.read<SettingsCubit>().toggleDarkMode(v),
                title: Text(l10n.darkMode),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: settings.languageCode,
                decoration: InputDecoration(labelText: l10n.language),
                items: [
                  DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                  DropdownMenuItem(value: 'ar', child: Text(l10n.arabic)),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  context.read<SettingsCubit>().setLanguage(value);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
