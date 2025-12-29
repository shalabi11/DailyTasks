import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task.dart';
import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';
import '../widgets/stats/stat_card.dart';
import '../widgets/stats/category_stat_bar.dart';
import '../widgets/stats/priority_stat_bar.dart';

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
              StatCard(
                title: l10n.statsTotal,
                value: tasks.length.toString(),
                icon: Icons.task_alt_rounded,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              StatCard(
                title: l10n.statsCompleted,
                value: completedTasks.toString(),
                icon: Icons.check_circle_rounded,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 12),
              StatCard(
                title: l10n.statsActive,
                value: activeTasks.toString(),
                icon: Icons.pending_actions_rounded,
                color: Colors.orange,
              ),
              const SizedBox(height: 12),
              StatCard(
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
                return CategoryStatBar(
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
                return PriorityStatBar(
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
