import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/tasks_cubit.dart';
import '../widgets/datetime_pickers/animated_date_picker.dart';
import '../widgets/datetime_pickers/animated_time_picker.dart';
import '../widgets/date_time_card.dart';
import '../widgets/animated_button.dart';
import '../utils/time_utils.dart';
import '../utils/dropdown_builders.dart';
import '../utils/task_form_utils.dart';

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
          child: SingleChildScrollView(
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
                DateTimeCard(
                  icon: Icons.calendar_today_rounded,
                  label: l10n.dueDateLabel,
                  value: formatDate(_dueDate, locale: localeTag),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 8),
                DateTimeCard(
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
                  items: buildCategoryItems(l10n),
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
                  items: buildPriorityItems(l10n),
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
                  items: buildRecurrenceItems(l10n),
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
                  items: buildReminderItems(l10n),
                  onChanged: (value) {
                    setState(() {
                      _reminderOffsetMinutes = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                AnimatedButton(
                  onPressed: _save,
                  label: l10n.save,
                  isPrimary: true,
                ),
                const SizedBox(height: 8),
                AnimatedButton(
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
    final title = _titleController.text;

    if (!validateTaskTitle(title)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.titleRequired)),
      );
      return;
    }

    final task = createTaskFromForm(
      title: title,
      dueDate: _dueDate,
      dueTime: _dueTime,
      category: _category,
      priority: _priority,
      recurrence: _recurrence,
      reminderOffsetMinutes: _reminderOffsetMinutes,
      existingTask: widget.existingTask,
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
