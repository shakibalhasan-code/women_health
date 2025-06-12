class PeriodData {
  final DateTime startDate;
  final DateTime endDate;
  final int cycleLength;
  final Map<DateTime, DailyData> dailyData;

  PeriodData({
    required this.startDate,
    required this.endDate,
    required this.cycleLength,
    this.dailyData = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'cycleLength': cycleLength,
      'dailyData': dailyData.map(
        (key, value) => MapEntry(key.toIso8601String(), value.toJson()),
      ),
    };
  }

  factory PeriodData.fromJson(Map<String, dynamic> json) {
    return PeriodData(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      cycleLength: json['cycleLength'],
      dailyData: (json['dailyData'] as Map<String, dynamic>?)?.map(
            (key, value) =>
                MapEntry(DateTime.parse(key), DailyData.fromJson(value)),
          ) ??
          {},
    );
  }
}

class DailyData {
  final String mood;
  final String symptoms;
  final int flow; // 1-5 scale
  final String notes;

  DailyData({
    this.mood = '',
    this.symptoms = '',
    this.flow = 0,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {'mood': mood, 'symptoms': symptoms, 'flow': flow, 'notes': notes};
  }

  factory DailyData.fromJson(Map<String, dynamic> json) {
    return DailyData(
      mood: json['mood'] ?? '',
      symptoms: json['symptoms'] ?? '',
      flow: json['flow'] ?? 0,
      notes: json['notes'] ?? '',
    );
  }
}

enum CyclePhase { menstruation, follicular, ovulation, luteal }
