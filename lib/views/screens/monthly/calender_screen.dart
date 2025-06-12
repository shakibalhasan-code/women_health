import 'package:flutter/material.dart';
import 'package:menstrual_cycle_widget/utils/enumeration.dart' as mc_enum;
import 'package:table_calendar/table_calendar.dart';
import 'package:women_health/core/models/period_data.dart';
import 'package:women_health/core/services/period_services.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final PeriodService _periodService = PeriodService();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<PeriodData> _periods = [];
  List<DateTime> _periodDates = [];
  List<DateTime> _predictedPeriods = [];
  List<DateTime> _predictedOvulation = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadData();
  }

  Future<void> _loadData() async {
    final periods = await _periodService.getPeriods();
    final predictions = _periodService.predictNextPeriods(periods, 3);

    setState(() {
      _periods = periods;
      _predictedPeriods = predictions;
      _periodDates = _getPeriodDates(periods);
      _predictedOvulation = _getOvulationDates(periods);
    });
  }

  List<DateTime> _getPeriodDates(List<PeriodData> periods) {
    List<DateTime> dates = [];
    for (var period in periods) {
      DateTime current = period.startDate;
      while (current.isBefore(period.endDate) ||
          current.isAtSameMomentAs(period.endDate)) {
        dates.add(current);
        current = current.add(Duration(days: 1));
      }
    }
    return dates;
  }

  List<DateTime> _getOvulationDates(List<PeriodData> periods) {
    return periods
        .map((period) {
          return _periodService.predictOvulation(
            period.startDate,
            period.cycleLength,
          );
        })
        .where((date) => date != null)
        .cast<DateTime>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        backgroundColor: Colors.pink.shade100,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Legend
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(Colors.pink, 'Period'),
                _buildLegendItem(Colors.green.shade300, 'Predicted Ovulation'),
                _buildLegendItem(Colors.pink.shade200, 'Predicted Period'),
                _buildLegendItem(Colors.blue, 'Selected'),
                _buildLegendItem(Colors.black, 'Today'),
              ],
            ),
          ),

          // Calendar
          Expanded(
            child: TableCalendar<DateTime>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _showDayDetails(selectedDay);
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return _buildCalendarDay(day, false, false, false, false);
                },
                todayBuilder: (context, day, focusedDay) {
                  return _buildCalendarDay(day, true, false, false, false);
                },
                selectedBuilder: (context, day, focusedDay) {
                  return _buildCalendarDay(day, false, true, false, false);
                },
              ),
            ),
          ),

          // Bottom buttons
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showLogPeriodDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Log Period',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _showDayDetails(_selectedDay ?? DateTime.now()),
                    child: Text('Add Daily Data'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildCalendarDay(
    DateTime day,
    bool isToday,
    bool isSelected,
    bool isPeriod,
    bool isPredicted,
  ) {
    Color? backgroundColor;
    Color textColor = Colors.black;

    if (_periodDates.any((date) => isSameDay(date, day))) {
      backgroundColor = Colors.pink;
      textColor = Colors.white;
    } else if (_predictedOvulation.any((date) => isSameDay(date, day))) {
      backgroundColor = Colors.green.shade300;
      textColor = Colors.white;
    } else if (_predictedPeriods.any((date) => isSameDay(date, day))) {
      backgroundColor = Colors.pink.shade200;
      textColor = Colors.white;
    } else if (isSelected) {
      backgroundColor = Colors.blue;
      textColor = Colors.white;
    } else if (isToday) {
      backgroundColor = Colors.black;
      textColor = Colors.white;
    }

    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showLogPeriodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Period'),
        content: Text(
          'Mark ${_selectedDay?.day}/${_selectedDay?.month} as a period day?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _logPeriodDay();
              Navigator.pop(context);
            },
            child: Text('Log'),
          ),
        ],
      ),
    );
  }

  void _logPeriodDay() async {
    if (_selectedDay == null) return;

    // Create new period or extend existing one
    final newPeriod = PeriodData(
      startDate: _selectedDay!,
      endDate: _selectedDay!.add(Duration(days: 4)), // Default 5 days
      cycleLength: 28, // Default cycle length
    );

    await _periodService.savePeriod(newPeriod);
    _loadData();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Period day logged!')));
  }

  void _showDayDetails(DateTime day) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DailyDataSheet(
        date: day,
        onSave: (data) async {
          await _periodService.updateDailyData(day, data);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class DailyDataSheet extends StatefulWidget {
  final DateTime date;
  final Function(DailyData) onSave;

  const DailyDataSheet({Key? key, required this.date, required this.onSave})
      : super(key: key);

  @override
  _DailyDataSheetState createState() => _DailyDataSheetState();
}

class _DailyDataSheetState extends State<DailyDataSheet> {
  String _selectedMood = '';
  String _symptoms = '';
  int _flow = 0;
  String _notes = '';

  final List<String> _moods = [
    'Happy',
    'Sad',
    'Anxious',
    'Energetic',
    'Tired',
    'Irritable',
  ];
  final List<String> _symptomsList = [
    'Cramps',
    'Headache',
    'Bloating',
    'Acne',
    'Breast tenderness',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Data - ${widget.date.day}/${widget.date.month}/${widget.date.year}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // Mood Selection
                Text(
                  'How are you feeling?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _moods
                      .map(
                        (mood) => FilterChip(
                          label: Text(mood),
                          selected: _selectedMood == mood,
                          onSelected: (selected) {
                            setState(() {
                              _selectedMood = selected ? mood : '';
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16),

                // Flow Intensity
                Text(
                  'Flow Intensity (1-5)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _flow.toDouble(),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: _flow == 0 ? 'None' : _flow.toString(),
                  onChanged: (value) {
                    setState(() {
                      _flow = value.toInt();
                    });
                  },
                ),
                SizedBox(height: 16),

                // Symptoms
                Text('Symptoms', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _symptomsList
                      .map(
                        (symptom) => FilterChip(
                          label: Text(symptom),
                          selected: _symptoms.contains(symptom),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _symptoms +=
                                    (_symptoms.isEmpty ? '' : ', ') + symptom;
                              } else {
                                _symptoms = _symptoms
                                    .replaceAll(symptom, '')
                                    .replaceAll(', ,', ',')
                                    .trim();
                                if (_symptoms.startsWith(','))
                                  _symptoms = _symptoms.substring(1).trim();
                                if (_symptoms.endsWith(','))
                                  _symptoms = _symptoms
                                      .substring(
                                        0,
                                        _symptoms.length - 1,
                                      )
                                      .trim();
                              }
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16),

                // Notes
                Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Add any additional notes...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _notes = value;
                  },
                ),
                SizedBox(height: 20),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final data = DailyData(
                        mood: _selectedMood,
                        symptoms: _symptoms,
                        flow: _flow,
                        notes: _notes,
                      );
                      widget.onSave(data);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
