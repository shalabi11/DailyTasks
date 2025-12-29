import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Builds filter menu items for task filtering
List<PopupMenuItem<String>> buildTaskFilterItems({
  required String selectedFilter,
  required AppLocalizations l10n,
}) {
  return [
    PopupMenuItem(
      value: 'all',
      child: Row(
        children: [
          Icon(
            selectedFilter == 'all' ? Icons.check : Icons.circle_outlined,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(l10n.filterAll),
        ],
      ),
    ),
    PopupMenuItem(
      value: 'active',
      child: Row(
        children: [
          Icon(
            selectedFilter == 'active' ? Icons.check : Icons.circle_outlined,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(l10n.filterActive),
        ],
      ),
    ),
    PopupMenuItem(
      value: 'completed',
      child: Row(
        children: [
          Icon(
            selectedFilter == 'completed'
                ? Icons.check
                : Icons.circle_outlined,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(l10n.filterCompleted),
        ],
      ),
    ),
  ];
}
