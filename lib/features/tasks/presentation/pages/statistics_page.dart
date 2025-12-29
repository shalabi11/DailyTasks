import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color(0xFF1F2937).withOpacity(0.85),
                      const Color(0xFF111827).withOpacity(0.75),
                    ]
                  : [
                      Colors.white.withOpacity(0.85),
                      const Color(0xFFF9FAFB).withOpacity(0.75),
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        title: Text(l10n.statsTitle),
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state is! TasksLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = state.tasks;
          final completedTasks = tasks.where((t) => t.isCompleted).length;
          final activeTasks = tasks.where((t) => !t.isCompleted).length;
          final completionRate = tasks.isEmpty
              ? 0.0
              : (completedTasks / tasks.length * 100);

          // Stats by category
          final categoryStats = <TaskCategory, int>{};
          for (var task in tasks) {
            categoryStats[task.category] =
                (categoryStats[task.category] ?? 0) + 1;
          }

          // Stats by priority
          final priorityStats = <TaskPriority, int>{};
          for (var task in tasks) {
            priorityStats[task.priority] =
                (priorityStats[task.priority] ?? 0) + 1;
          }

          return ListView(
            padding: const EdgeInsets.only(
              top: 100,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            children: [
              _StatCard(
                title: l10n.statsTotal,
                value: tasks.length.toString(),
                icon: Icons.task_alt_rounded,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: l10n.statsCompleted,
                value: completedTasks.toString(),
                icon: Icons.check_circle_rounded,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: l10n.statsActive,
                value: activeTasks.toString(),
                icon: Icons.pending_actions_rounded,
                color: Colors.orange,
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: l10n.statsCompletionRate,
                value: '${completionRate.toStringAsFixed(1)}%',
                icon: Icons.trending_up_rounded,
                color: completionRate > 50 ? Colors.green : Colors.amber,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.statsByCategory,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...categoryStats.entries.map((entry) {
                return _CategoryStatBar(
                  category: entry.key,
                  count: entry.value,
                  total: tasks.length,
                );
              }),
              const SizedBox(height: 24),
              Text(
                l10n.statsByPriority,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...priorityStats.entries.map((entry) {
                return _PriorityStatBar(
                  priority: entry.key,
                  count: entry.value,
                  total: tasks.length,
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey.shade300).withOpacity(
              0.15,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryStatBar extends StatelessWidget {
  const _CategoryStatBar({
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

class _PriorityStatBar extends StatelessWidget {
  const _PriorityStatBar({
    required this.priority,
    required this.count,
    required this.total,
  });

  final TaskPriority priority;
  final int count;
  final int total;

  String _getPriorityName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (priority) {
      case TaskPriority.low:
        return l10n.priorityLow;
      case TaskPriority.medium:
        return l10n.priorityMedium;
      case TaskPriority.high:
        return l10n.priorityHigh;
    }
  }

  Color _getPriorityColor() {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (count / total * 100).toStringAsFixed(0);
    final color = _getPriorityColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getPriorityName(context),
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
