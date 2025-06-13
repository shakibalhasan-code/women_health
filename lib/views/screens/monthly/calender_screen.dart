import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:women_health/core/models/period_data.dart';

import '../../../controller/period_data_controller.dart';
import 'daily_data_sheet.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final PeriodController controller = Get.find<PeriodController>();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late List<DateTime> _periodDaysCache;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _periodDaysCache = _getAllPeriodDays();
  }

  List<DateTime> _getAllPeriodDays() {
    final List<DateTime> dates = [];
    for (final period in controller.allPeriods) {
      for (int i = 0; i <= period.endDate.difference(period.startDate).inDays; i++) {
        dates.add(period.startDate.add(Duration(days: i)));
      }
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle Calendar'),
        backgroundColor: Colors.pink.shade50,
        elevation: 1,
      ),
      body: GetBuilder<PeriodController>(
        id: PeriodController.calendarUpdateId,
        builder: (controller) {
          _periodDaysCache = _getAllPeriodDays();

          return Column(
            children: [
              _buildLegend(),
              Expanded(
                child: TableCalendar<DateTime>(
                  firstDay: DateTime.utc(2021, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: (day) {
                    return controller.allOvulationDates.where((d) => isSameDay(d, day)).toList();
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) => _buildCalendarDay(day),
                    todayBuilder: (context, day, focusedDay) => _buildCalendarDay(day, isToday: true),
                    selectedBuilder: (context, day, focusedDay) => _buildCalendarDay(day, isSelected: true),
                    markerBuilder: (context, day, events) {
                      if (events.isNotEmpty) {
                        return Container(
                          width: 7, height: 7, margin: const EdgeInsets.only(top: 25),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.shade400),
                        );
                      }
                      return null;
                    },
                  ),
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) setState(() { _calendarFormat = format; });
                  },
                  onPageChanged: (focusedDay) { _focusedDay = focusedDay; },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showLogPeriodDialog(context, controller),
                        child: const Text('Log Period Start'),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showDayDetails(_selectedDay ?? DateTime.now()),
                        child: const Text('Log Symptoms'),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendarDay(DateTime day, {bool isSelected = false, bool isToday = false}) {
    Color backgroundColor = Colors.transparent;
    Color textColor = Colors.black87;
    BoxDecoration decoration;

    if (_periodDaysCache.any((d) => isSameDay(d, day))) {
      backgroundColor = Colors.red.shade400;
      textColor = Colors.white;
    } else if (controller.nextPredictedPeriods.any((d) => isSameDay(d, day))) {
      backgroundColor = Colors.pink.shade100;
      textColor = Colors.pink.shade800;
    }

    if (isSelected) {
      decoration = BoxDecoration(color: Colors.blue.shade300, shape: BoxShape.circle);
      textColor = Colors.white;
    } else if (isToday) {
      decoration = BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.blue.shade600, width: 2),
        shape: BoxShape.circle,
      );
      if (backgroundColor == Colors.transparent) textColor = Colors.blue.shade600;
    } else {
      decoration = BoxDecoration(color: backgroundColor, shape: BoxShape.circle);
    }

    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: decoration,
      child: Center(child: Text('${day.day}', style: TextStyle(color: textColor, fontWeight: FontWeight.bold))),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Wrap(
        alignment: WrapAlignment.center, spacing: 16.0, runSpacing: 8.0,
        children: [
          _buildLegendItem(Colors.red.shade400, 'Period'),
          _buildLegendItem(Colors.pink.shade100, 'Predicted Period'),
          _buildLegendItem(Colors.green.shade400, 'Ovulation (dot)'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6), Text(label, style: const TextStyle(fontSize: 12)),
    ]);
  }

  void _showLogPeriodDialog(BuildContext context, PeriodController controller) {
    final selected = _selectedDay ?? DateTime.now();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log New Period"),
        content: Text("Did your period start on ${selected.day}/${selected.month}/${selected.year}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              controller.logNewPeriod(selected);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("New period logged!")));
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void _showDayDetails(DateTime day) {
    final existingData = controller.getDailyDataFor(day);
    showModalBottomSheet<void>(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DailyDataSheet(
          date: day, initialData: existingData,
          onSave: (DailyData data) {
            controller.updateDailyLog(day, data);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log saved!')));
          },
        );
      },
    );
  }
}