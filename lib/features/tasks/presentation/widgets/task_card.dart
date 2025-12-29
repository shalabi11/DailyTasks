import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/task.dart';
import '../../../../l10n/app_localizations.dart';

class TaskCard extends StatefulWidget {
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
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = theme.colorScheme.onSurfaceVariant;
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );

    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final dueText = DateFormat.yMMMd(
      localeTag,
    ).add_jm().format(widget.task.dueAt);
    final reminderText = widget.task.reminderOffsetMinutes == null
        ? null
        : '• ${l10n.reminderMinutesBeforeShort(widget.task.reminderOffsetMinutes!)}';

    // Task icon based on completion
    final taskIcon = widget.task.isCompleted
        ? Icons.check_circle_rounded
        : Icons.radio_button_unchecked_rounded;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) {
            _controller.forward();
          },
          onTapUp: (_) {
            _controller.reverse();
          },
          onTapCancel: () {
            _controller.reverse();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(
              horizontal: _isHovered ? 2 : 0,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.grey.shade300)
                      .withOpacity(_isHovered ? 0.4 : 0.15),
                  blurRadius: _isHovered ? 16 : 8,
                  offset: Offset(0, _isHovered ? 6 : 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onEdit,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: widget.task.isCompleted
                        ? LinearGradient(
                            colors: [
                              theme.cardTheme.color!,
                              theme.colorScheme.secondary.withOpacity(0.03),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Animated icon/checkbox area
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: widget.task.isCompleted
                              ? theme.colorScheme.secondary.withOpacity(0.15)
                              : theme.colorScheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              taskIcon,
                              key: ValueKey(widget.task.isCompleted),
                              color: widget.task.isCompleted
                                  ? theme.colorScheme.secondary
                                  : theme.colorScheme.primary,
                            ),
                          ),
                          onPressed: widget.onToggleCompleted,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: titleStyle!.copyWith(
                                color: widget.task.isCompleted
                                    ? secondary
                                    : theme.colorScheme.onSurface,
                                fontSize: _isHovered ? 16.5 : 16,
                              ),
                              child: Text(
                                widget.task.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 14,
                                  color: secondary,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      color: secondary,
                                      fontSize: _isHovered ? 12.5 : 12,
                                    ),
                                    child: Text(
                                      reminderText == null
                                          ? dueText
                                          : '$dueText $reminderText',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Delete button
                      AnimatedScale(
                        scale: _isHovered ? 1.0 : 0.9,
                        duration: const Duration(milliseconds: 200),
                        child: AnimatedOpacity(
                          opacity: _isHovered ? 1.0 : 0.7,
                          duration: const Duration(milliseconds: 200),
                          child: IconButton(
                            tooltip: l10n.delete,
                            onPressed: widget.onDelete,
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: theme.colorScheme.error,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.error
                                  .withOpacity(0.08),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
