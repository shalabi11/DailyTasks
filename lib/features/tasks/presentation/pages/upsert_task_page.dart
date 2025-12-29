import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/tasks_cubit.dart';
import '../widgets/datetime_pickers/animated_date_picker.dart';
import '../widgets/datetime_pickers/animated_time_picker.dart';
import '../utils/time_utils.dart';

class UpsertTaskPage extends StatefulWidget {
  const UpsertTaskPage({super.key, this.existingTask});

  final Task? existingTask;

  @override
  State<UpsertTaskPage> createState() => _UpsertTaskPageState();
}

class _UpsertTaskPageState extends State<UpsertTaskPage>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _titleController;
  late DateTime _dueDate;
  late TimeOfDay _dueTime;
  int? _reminderOffsetMinutes;
  late TaskCategory _category;
  late TaskPriority _priority;
  late RecurrenceType _recurrence;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool get _isEdit => widget.existingTask != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingTask?.title ?? '',
    );
    final existingDueAt = widget.existingTask?.dueAt;
    final initialDueAt = existingDueAt ?? DateTime.now();
    _dueDate = DateUtils.dateOnly(initialDueAt);
    _dueTime = TimeOfDay.fromDateTime(existingDueAt ?? DateTime.now());
    _reminderOffsetMinutes = widget.existingTask?.reminderOffsetMinutes;
    _category = widget.existingTask?.category ?? TaskCategory.other;
    _priority = widget.existingTask?.priority ?? TaskPriority.medium;
    _recurrence = widget.existingTask?.recurrence ?? RecurrenceType.none;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );
    _animController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pageTitle = _isEdit ? l10n.editTask : l10n.addTask;
    final localeTag = Localizations.localeOf(context).toLanguageTag();

    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: l10n.titleLabel,
                    prefixIcon: const Icon(Icons.edit_rounded),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 16),
                _DateTimeCard(
                  icon: Icons.calendar_today_rounded,
                  label: l10n.dueDateLabel,
                  value: formatDate(_dueDate, locale: localeTag),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 8),
                _DateTimeCard(
                  icon: Icons.access_time_rounded,
                  label: l10n.dueTimeLabel,
                  value: formatTime(_dueTime, locale: localeTag),
                  onTap: _pickTime,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TaskCategory>(
                  value: _category,
                  decoration: InputDecoration(
                    labelText: l10n.categoryLabel,
                    prefixIcon: const Icon(Icons.category_rounded),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: TaskCategory.work,
                      child: Text(l10n.categoryWork),
                    ),
                    DropdownMenuItem(
                      value: TaskCategory.personal,
                      child: Text(l10n.categoryPersonal),
                    ),
                    DropdownMenuItem(
                      value: TaskCategory.urgent,
                      child: Text(l10n.categoryUrgent),
                    ),
                    DropdownMenuItem(
                      value: TaskCategory.shopping,
                      child: Text(l10n.categoryShopping),
                    ),
                    DropdownMenuItem(
                      value: TaskCategory.health,
                      child: Text(l10n.categoryHealth),
                    ),
                    DropdownMenuItem(
                      value: TaskCategory.other,
                      child: Text(l10n.categoryOther),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _category = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TaskPriority>(
                  value: _priority,
                  decoration: InputDecoration(
                    labelText: l10n.priorityLabel,
                    prefixIcon: const Icon(Icons.flag_rounded),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: TaskPriority.low,
                      child: Text(l10n.priorityLow),
                    ),
                    DropdownMenuItem(
                      value: TaskPriority.medium,
                      child: Text(l10n.priorityMedium),
                    ),
                    DropdownMenuItem(
                      value: TaskPriority.high,
                      child: Text(l10n.priorityHigh),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _priority = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<RecurrenceType>(
                  value: _recurrence,
                  decoration: InputDecoration(
                    labelText: l10n.recurrenceLabel,
                    prefixIcon: const Icon(Icons.repeat_rounded),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: RecurrenceType.none,
                      child: Text(l10n.recurrenceNone),
                    ),
                    DropdownMenuItem(
                      value: RecurrenceType.daily,
                      child: Text(l10n.recurrenceDaily),
                    ),
                    DropdownMenuItem(
                      value: RecurrenceType.weekly,
                      child: Text(l10n.recurrenceWeekly),
                    ),
                    DropdownMenuItem(
                      value: RecurrenceType.monthly,
                      child: Text(l10n.recurrenceMonthly),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _recurrence = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int?>(
                  value: _reminderOffsetMinutes,
                  decoration: InputDecoration(
                    labelText: l10n.reminderLabel,
                    prefixIcon: const Icon(Icons.notifications_rounded),
                  ),
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text(l10n.reminderOff),
                    ),
                    DropdownMenuItem<int?>(
                      value: 5,
                      child: Text(l10n.reminderMinutesBefore(5)),
                    ),
                    DropdownMenuItem<int?>(
                      value: 10,
                      child: Text(l10n.reminderMinutesBefore(10)),
                    ),
                    DropdownMenuItem<int?>(
                      value: 30,
                      child: Text(l10n.reminderMinutesBefore(30)),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _reminderOffsetMinutes = value;
                    });
                  },
                ),
                const Spacer(),
                _AnimatedButton(
                  onPressed: _save,
                  label: l10n.save,
                  isPrimary: true,
                ),
                const SizedBox(height: 8),
                _AnimatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  label: l10n.cancel,
                  isPrimary: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    await showDialog(
      context: context,
      builder: (context) => AnimatedDatePicker(
        initialDate: _dueDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        locale: Localizations.localeOf(context).languageCode,
        onDateSelected: (picked) {
          setState(() {
            _dueDate = DateUtils.dateOnly(picked);
          });
        },
      ),
    );
  }

  Future<void> _pickTime() async {
    await showDialog(
      context: context,
      builder: (context) => AnimatedTimePicker(
        initialTime: _dueTime,
        onTimeSelected: (picked) {
          setState(() {
            _dueTime = picked;
          });
        },
      ),
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.titleRequired)));
      return;
    }

    final dueAt = DateTime(
      _dueDate.year,
      _dueDate.month,
      _dueDate.day,
      _dueTime.hour,
      _dueTime.minute,
    );

    final task = Task(
      id: widget.existingTask?.id ?? const Uuid().v4(),
      title: title,
      dueAt: dueAt,
      isCompleted: widget.existingTask?.isCompleted ?? false,
      reminderOffsetMinutes: _reminderOffsetMinutes,
      category: _category,
      priority: _priority,
      recurrence: _recurrence,
      completedAt: widget.existingTask?.completedAt,
    );

    final cubit = context.read<TasksCubit>();
    if (_isEdit) {
      await cubit.update(task);
    } else {
      await cubit.add(task);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }
}

class _DateTimeCard extends StatefulWidget {
  const _DateTimeCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  State<_DateTimeCard> createState() => _DateTimeCardState();
}

class _DateTimeCardState extends State<_DateTimeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.grey.shade300).withOpacity(
                _isHovered ? 0.3 : 0.1,
              ),
              blurRadius: _isHovered ? 8 : 4,
              offset: Offset(0, _isHovered ? 3 : 1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.icon,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.value,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  const _AnimatedButton({
    required this.onPressed,
    required this.label,
    required this.isPrimary,
  });

  final VoidCallback onPressed;
  final String label;
  final bool isPrimary;

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
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
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.isPrimary
            ? ElevatedButton(
                onPressed: widget.onPressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : TextButton(
                onPressed: widget.onPressed,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(widget.label, style: const TextStyle(fontSize: 16)),
              ),
      ),
    );
  }
}
