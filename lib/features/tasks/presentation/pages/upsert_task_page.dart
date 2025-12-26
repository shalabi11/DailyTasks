import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/tasks_cubit.dart';

class UpsertTaskPage extends StatefulWidget {
  const UpsertTaskPage({super.key, this.existingTask});

  final Task? existingTask;

  @override
  State<UpsertTaskPage> createState() => _UpsertTaskPageState();
}

class _UpsertTaskPageState extends State<UpsertTaskPage> {
  late final TextEditingController _titleController;
  late DateTime _dueDate;
  late TimeOfDay _dueTime;
  int? _reminderOffsetMinutes;

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
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pageTitle = _isEdit ? l10n.editTask : l10n.addTask;
    final localeTag = Localizations.localeOf(context).toLanguageTag();

    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: l10n.titleLabel),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.dueDateLabel}: ${DateFormat.yMMMd(localeTag).format(_dueDate)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(onPressed: _pickDate, child: Text(l10n.pick)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.dueTimeLabel}: ${_dueTime.format(context)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(onPressed: _pickTime, child: Text(l10n.pick)),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int?>(
              initialValue: _reminderOffsetMinutes,
              decoration: InputDecoration(labelText: l10n.reminderLabel),
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
            ElevatedButton(onPressed: _save, child: Text(l10n.save)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      _dueDate = DateUtils.dateOnly(picked);
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime,
    );

    if (picked == null) return;

    setState(() {
      _dueTime = picked;
    });
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
