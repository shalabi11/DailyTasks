import 'package:flutter/material.dart';

import '../../../domain/entities/task.dart';
import '../../../../../l10n/app_localizations.dart';

class CategoryStatBar extends StatelessWidget {
  const CategoryStatBar({
    required this.category,
    required this.count,
    required this.total,
  });

  final TaskCategory category;
  final int count;
  final int total;

  String _getCategoryName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (category) {
      case TaskCategory.work:
        return l10n.categoryWork;
      case TaskCategory.personal:
        return l10n.categoryPersonal;
      case TaskCategory.urgent:
        return l10n.categoryUrgent;
      case TaskCategory.shopping:
        return l10n.categoryShopping;
      case TaskCategory.health:
        return l10n.categoryHealth;
      case TaskCategory.other:
        return l10n.categoryOther;
    }
  }

  Color _getCategoryColor() {
    switch (category) {
      case TaskCategory.work:
        return Colors.blue;
      case TaskCategory.personal:
        return Colors.green;
      case TaskCategory.urgent:
        return Colors.red;
      case TaskCategory.shopping:
        return Colors.purple;
      case TaskCategory.health:
        return Colors.pink;
      case TaskCategory.other:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (count / total * 100).toStringAsFixed(0);
    final color = _getCategoryColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getCategoryName(context),
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                '$count ($percentage%)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: count / total,
              minHeight: 8,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
