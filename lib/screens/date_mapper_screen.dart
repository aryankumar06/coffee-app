import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// Color Palette
const Color textPrimary = Color(0xFF30364F); // Dark Blue/Navy
const Color primaryAccent = Color(0xFFACBAC4); // Light Blue/Greyish
const Color secondaryAccent = Color(0xFFE1D9BC); // Beige/Sand
const Color backgroundLight = Color(0xFFF0F0DB); // Light Beige/Off-white

class DateMapperScreen extends StatefulWidget {
  const DateMapperScreen({super.key});

  @override
  State<DateMapperScreen> createState() => _DateMapperScreenState();
}

class _DateMapperScreenState extends State<DateMapperScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Mock data for our calendar schedules
  // 0: none, 1: weekly recurring, 2: specific date override
  final Map<DateTime, int> _mockSchedules = {
    DateTime(2026, 3, 14): 1,
    DateTime(2026, 3, 15): 1,
    DateTime(2026, 3, 16): 2,
    DateTime(2026, 3, 20): 1,
    DateTime(2026, 3, 21): 2,
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  int _getScheduleTypeForDay(DateTime day) {
    for (var d in _mockSchedules.keys) {
      if (isSameDay(d, day)) {
        return _mockSchedules[d]!;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Menu Scheduler',
          style: TextStyle(fontWeight: FontWeight.bold, color: backgroundLight),
        ),
        backgroundColor: textPrimary,
        elevation: 0,
        iconTheme: const IconThemeData(color: backgroundLight),
      ),
      body: Column(
        children: [
          _buildCalendar(),
          const Divider(height: 1, color: primaryAccent,),
          Expanded(child: _buildDetailsPanel()),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      color: Colors.white,
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: textPrimary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: primaryAccent.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          weekendTextStyle: const TextStyle(color: textPrimary),
          defaultTextStyle: const TextStyle(color: textPrimary),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
          leftChevronIcon: Icon(Icons.chevron_left, color: textPrimary),
          rightChevronIcon: Icon(Icons.chevron_right, color: textPrimary),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            final scheduleType = _getScheduleTypeForDay(date);
            if (scheduleType == 0) {
              return null; // No dot
            } else if (scheduleType == 1) {
              // Weekly recurring
              return Positioned(
                bottom: 4,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: primaryAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            } else {
              // Specific override
              return Positioned(
                bottom: 4,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailsPanel() {
    if (_selectedDay == null) return const SizedBox();

    final scheduleType = _getScheduleTypeForDay(_selectedDay!);
    String statusText = "No Menu Assigned";
    String templateName = "-";
    IconData statusIcon = Icons.info_outline;
    Color statusColor = textPrimary;

    if (scheduleType == 1) {
      statusText = "Weekly Recurring Template";
      templateName = "Weekend Brunch Template";
      statusIcon = Icons.autorenew;
      statusColor = primaryAccent;
    } else if (scheduleType == 2) {
      statusText = "Specific Date Override";
      templateName = "Summer Special";
      statusIcon = Icons.star;
      statusColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(24.0),
      width: double.infinity,
      color: backgroundLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE, MMM d').format(_selectedDay!),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: secondaryAccent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(statusIcon, color: textPrimary, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusText,
                        style: TextStyle(
                            fontSize: 14,
                            color: textPrimary.withOpacity(0.8),
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        templateName,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.swap_horiz, color: backgroundLight),
                  label: const Text("Change Template", style: TextStyle(color: backgroundLight),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (scheduleType != 0)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: textPrimary),
                    label: const Text(
                      "Edit Items for Today",
                      style: TextStyle(color: textPrimary),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: textPrimary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
