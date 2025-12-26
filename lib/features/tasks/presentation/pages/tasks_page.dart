import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_page_route.dart';
import '../../domain/entities/task.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';
import '../widgets/task_card.dart';
import 'upsert_task_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Task> _tasks = <Task>[];
  var _syncedOnce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_syncedOnce) return;

    final state = context.read<TasksCubit>().state;
    if (state is TasksLoaded) {
      _tasks
        ..clear()
        ..addAll(state.tasks);
      _syncedOnce = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dailyTasks),
        actions: [
          IconButton(
            tooltip: l10n.settings,
            onPressed: () => _openSettings(context),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is! TasksLoaded) return;
          _syncAnimatedList(state.tasks);
        },
        builder: (context, state) {
          if (state is TasksLoading || state is TasksInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TasksError) {
            return Center(
              child: Text(state.message, textAlign: TextAlign.center),
            );
          }

          if (_tasks.isEmpty) {
            return Center(child: Text(l10n.noTasksYet));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth >= 700
                  ? 640.0
                  : constraints.maxWidth;
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: AnimatedList(
                      key: _listKey,
                      initialItemCount: _tasks.length,
                      itemBuilder: (context, index, animation) {
                        final task = _tasks[index];
                        return SizeTransition(
                          sizeFactor: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: KeyedSubtree(
                                key: ValueKey(task),
                                child: TaskCard(
                                  task: task,
                                  onToggleCompleted: () => context
                                      .read<TasksCubit>()
                                      .toggleCompleted(task),
                                  onEdit: () =>
                                      _openUpsert(context, task: task),
                                  onDelete: () => context
                                      .read<TasksCubit>()
                                      .delete(task.id),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openUpsert(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _syncAnimatedList(List<Task> latest) {
    final latestOrder = latest.map((t) => t.id).toList(growable: false);
    final latestIds = latestOrder.toSet();
    var didInsertOrRemove = false;

    // Remove items not present anymore.
    for (var i = _tasks.length - 1; i >= 0; i--) {
      final task = _tasks[i];
      if (!latestIds.contains(task.id)) {
        final removed = _tasks.removeAt(i);
        didInsertOrRemove = true;
        _listKey.currentState?.removeItem(i, (context, animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: FadeTransition(
              opacity: animation,
              child: TaskCard(
                task: removed,
                onToggleCompleted: () {},
                onEdit: () {},
                onDelete: () {},
              ),
            ),
          );
        }, duration: const Duration(milliseconds: 220));
      }
    }

    final currentIds = _tasks.map((t) => t.id).toSet();

    // Insert new items.
    for (var i = 0; i < latest.length; i++) {
      final task = latest[i];
      if (!currentIds.contains(task.id)) {
        _tasks.insert(i, task);
        didInsertOrRemove = true;
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 220),
        );
      }
    }

    // Update existing items (no reorder animation).
    final byId = {for (final t in latest) t.id: t};
    for (var i = 0; i < _tasks.length; i++) {
      final updated = byId[_tasks[i].id];
      if (updated != null) _tasks[i] = updated;
    }

    // If the list is sorted by due date/time, edits can change ordering.
    // AnimatedList doesn't support reordering animations, so we update the
    // backing list order directly (only when item count didn't change).
    if (!didInsertOrRemove) {
      final currentOrder = _tasks.map((t) => t.id).toList(growable: false);
      if (!listEquals(currentOrder, latestOrder)) {
        _tasks
          ..clear()
          ..addAll(latestOrder.map((id) => byId[id]!).toList(growable: false));
      }
    }

    setState(() {
      _syncedOnce = true;
    });
  }

  void _openUpsert(BuildContext context, {Task? task}) {
    Navigator.of(
      context,
    ).push(fadeSlideRoute(UpsertTaskPage(existingTask: task)));
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(fadeSlideRoute(const SettingsPage()));
  }
}
