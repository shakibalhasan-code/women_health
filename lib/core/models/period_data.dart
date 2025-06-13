import 'package:flutter/foundation.dart'; // For kDebugMode

class PeriodData {
  final DateTime startDate;
  final DateTime endDate;
  final int cycleLength;
  // <<< CHANGE: The key is now a String in 'YYYY-MM-DD' format.
  final Map<String, DailyData> dailyData;

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
      // <<< CHANGE: The key is already a string, so we just serialize the value.
      // This is simpler and more robust.
      'dailyData': dailyData.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  factory PeriodData.fromJson(Map<String, dynamic> json) {
    try {
      return PeriodData(
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        cycleLength: json['cycleLength'] ?? 0, // Added null check for safety
        // <<< CHANGE: The key is a string, and we deserialize the value.
        dailyData: (json['dailyData'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, DailyData.fromJson(value)),
        ) ??
            {},
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing PeriodData: $e");
        print("Problematic JSON: $json");
      }
      // Return a default/empty object to prevent app crash on bad data
      return PeriodData(startDate: DateTime.now(), endDate: DateTime.now(), cycleLength: 0);
    }
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
    return {
      'mood': mood,
      'symptoms': symptoms,
      'flow': flow,
      'notes': notes,
    };
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

// Keep the enum in this central model file for easy access across the app.
enum CyclePhase { menstruation, follicular, ovulation, luteal }