import 'dart:math' as math;
import 'package:flutter/material.dart';

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
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
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
    widget.onTimeSelected(TimeOfDay(hour: _selectedHour, minute: _selectedMinute));
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
                          _TimeSegment(
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
                          _TimeSegment(
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
                    child: _CircularDial(
                      selectedValue: _isSelectingHour ? _selectedHour : _selectedMinute,
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

class _TimeSegment extends StatelessWidget {
  const _TimeSegment({
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.onPrimary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 48,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

class _CircularDial extends StatefulWidget {
  const _CircularDial({
    required this.selectedValue,
    required this.maxValue,
    required this.onValueSelected,
    required this.isHourMode,
  });

  final int selectedValue;
  final int maxValue;
  final Function(int) onValueSelected;
  final bool isHourMode;

  @override
  State<_CircularDial> createState() => _CircularDialState();
}

class _CircularDialState extends State<_CircularDial> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = 280.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Clock face
          CustomPaint(
            size: Size(size, size),
            painter: _ClockFacePainter(
              selectedValue: widget.selectedValue,
              maxValue: widget.maxValue,
              color: colorScheme.primary,
              isHourMode: widget.isHourMode,
            ),
          ),
          // Numbers
          ...List.generate(
            widget.isHourMode ? 24 : 12,
            (index) {
              final value = widget.isHourMode
                  ? index
                  : index * 5;
              final angle = (math.pi * 2 * value) /
                  (widget.isHourMode ? 24 : 60) -
                  math.pi / 2;
              final radius = size / 2 - 30;
              final x = size / 2 + radius * math.cos(angle);
              final y = size / 2 + radius * math.sin(angle);

              final isSelected = value == widget.selectedValue;

              return Positioned(
                left: x - 20,
                top: y - 20,
                child: GestureDetector(
                  onTap: () => widget.onValueSelected(value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : theme.textTheme.bodyLarge?.color,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: isSelected ? 16 : 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ClockFacePainter extends CustomPainter {
  _ClockFacePainter({
    required this.selectedValue,
    required this.maxValue,
    required this.color,
    required this.isHourMode,
  });

  final int selectedValue;
  final int maxValue;
  final Color color;
  final bool isHourMode;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 30;

    // Draw circle outline
    final outlinePaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, outlinePaint);

    // Draw selection indicator line
    final angle = (math.pi * 2 * selectedValue) / (isHourMode ? 24 : 60) -
        math.pi / 2;
    final lineEnd = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(center, lineEnd, linePaint);

    // Draw center dot
    final centerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 6, centerPaint);
  }

  @override
  bool shouldRepaint(_ClockFacePainter oldDelegate) =>
      selectedValue != oldDelegate.selectedValue ||
      isHourMode != oldDelegate.isHourMode;
}
