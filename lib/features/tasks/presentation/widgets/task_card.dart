import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/task.dart';
import '../../../../l10n/app_localizations.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleCompleted,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggleCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final secondary = theme.colorScheme.onSurfaceVariant;
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );

    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final dueText = DateFormat.yMMMd(localeTag).add_jm().format(task.dueAt);
    final reminderText = task.reminderOffsetMinutes == null
        ? null
        : '• ${l10n.reminderMinutesBeforeShort(task.reminderOffsetMinutes!)}';

    return Card(
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (_) => onToggleCompleted(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: task.isCompleted ? 0.65 : 1,
                      child: Text(
                        task.title,
                        style: titleStyle?.copyWith(
                          color: task.isCompleted
                              ? secondary
                              : theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reminderText == null ? dueText : '$dueText $reminderText',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: secondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.delete,
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
