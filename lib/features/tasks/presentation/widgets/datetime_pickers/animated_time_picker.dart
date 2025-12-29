import 'package:flutter/material.dart';

import 'time_segment.dart';
import 'circular_dial.dart';

class AnimatedTimePicker extends StatefulWidget {
  const AnimatedTimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeSelected,
  });

  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeSelected;

  @override
  State<AnimatedTimePicker> createState() => _AnimatedTimePickerState();
}

class _AnimatedTimePickerState extends State<AnimatedTimePicker>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _dialController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late int _selectedHour;
  late int _selectedMinute;
  bool _isSelectingHour = true;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _dialController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _dialController.dispose();
    super.dispose();
  }

  void _toggleSelection() {
    setState(() {
      _isSelectingHour = !_isSelectingHour;
    });
    _dialController.forward(from: 0.0);
  }

  void _onConfirm() {
    widget.onTimeSelected(
      TimeOfDay(hour: _selectedHour, minute: _selectedMinute),
    );
    Navigator.of(context).pop();
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
            constraints: const BoxConstraints(maxWidth: 400),
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
                            Icons.access_time_rounded,
                            color: colorScheme.onPrimary,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Select Time',
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TimeSegment(
                            value: _selectedHour.toString().padLeft(2, '0'),
                            isSelected: _isSelectingHour,
                            onTap: () {
                              if (!_isSelectingHour) _toggleSelection();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              ':',
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontSize: 48,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          TimeSegment(
                            value: _selectedMinute.toString().padLeft(2, '0'),
                            isSelected: !_isSelectingHour,
                            onTap: () {
                              if (_isSelectingHour) _toggleSelection();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Circular Dial
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: FadeTransition(
                    opacity: _dialController,
                    child: CircularDial(
                      selectedValue: _isSelectingHour
                          ? _selectedHour
                          : _selectedMinute,
                      maxValue: _isSelectingHour ? 23 : 59,
                      onValueSelected: (value) {
                        setState(() {
                          if (_isSelectingHour) {
                            _selectedHour = value;
                          } else {
                            _selectedMinute = value;
                          }
                        });
                      },
                      isHourMode: _isSelectingHour,
                    ),
                  ),
                ),
                // Actions
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _onConfirm,
                        child: const Text('Confirm'),
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
