import 'package:flutter/material.dart';

import '../../../domain/entities/task.dart';
import '../../../../../l10n/app_localizations.dart';

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({required this.category});

  final TaskCategory category;

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
    final color = _getCategoryColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getCategoryName(context),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
