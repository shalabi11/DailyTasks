import 'package:flutter/material.dart';

import 'date_range_display.dart';

class AnimatedDateRangePicker extends StatefulWidget {
  const AnimatedDateRangePicker({
    super.key,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onRangeSelected,
    this.firstDate,
    this.lastDate,
    this.locale,
  });

  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final Function(DateTime startDate, DateTime endDate) onRangeSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? locale;

  @override
  State<AnimatedDateRangePicker> createState() =>
      _AnimatedDateRangePickerState();
}

class _AnimatedDateRangePickerState extends State<AnimatedDateRangePicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (_startDate != null && _endDate != null) {
      widget.onRangeSelected(_startDate!, _endDate!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450, maxHeight: 700),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.date_range_rounded,
                            color: colorScheme.onPrimary,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Select Date Range',
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DateRangeDisplay(
                              label: 'Start Date',
                              date: _startDate,
                              locale: widget.locale,
                              colorScheme: colorScheme,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DateRangeDisplay(
                              label: 'End Date',
                              date: _endDate,
                              locale: widget.locale,
                              colorScheme: colorScheme,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Calendar
                Expanded(
                  child: Theme(
                    data: theme.copyWith(
                      colorScheme: colorScheme.copyWith(
                        onSurface: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    child: CalendarDatePicker(
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: widget.firstDate ?? DateTime(2000),
                      lastDate: widget.lastDate ?? DateTime(2100),
                      onDateChanged: (date) {
                        setState(() {
                          if (_startDate == null || _endDate != null) {
                            // Start new range
                            _startDate = date;
                            _endDate = null;
                          } else {
                            // Complete range
                            if (date.isBefore(_startDate!)) {
                              _endDate = _startDate;
                              _startDate = date;
                            } else {
                              _endDate = date;
                            }
                          }
                        });
                      },
                    ),
                  ),
                ),
                // Helper text
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Text(
                    _startDate == null
                        ? 'Select start date'
                        : _endDate == null
                        ? 'Select end date'
                        : 'Range selected',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Actions
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _startDate = widget.initialStartDate;
                            _endDate = widget.initialEndDate;
                          });
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Reset'),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: _startDate != null && _endDate != null
                                ? _onConfirm
                                : null,
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
