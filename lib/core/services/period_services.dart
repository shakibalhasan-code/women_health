import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/core/models/period_data.dart';

class PeriodService {
  static const String _periodsKey = 'periods_data';

  Future<List<PeriodData>> getPeriods() async {
    final prefs = await SharedPreferences.getInstance();
    final periodsJson = prefs.getStringList(_periodsKey) ?? [];
    return periodsJson
        .map((json) => PeriodData.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> savePeriod(PeriodData period) async {
    final periods = await getPeriods();
    periods.add(period);
    await _savePeriods(periods);
  }

  Future<void> _savePeriods(List<PeriodData> periods) async {
    final prefs = await SharedPreferences.getInstance();
    final periodsJson =
        periods.map((period) => jsonEncode(period.toJson())).toList();
    await prefs.setStringList(_periodsKey, periodsJson);
  }

  Future<void> updateDailyData(DateTime date, DailyData data) async {
    final periods = await getPeriods();
    // Find the period that contains this date and update daily data
    for (var period in periods) {
      if (date.isAfter(period.startDate.subtract(Duration(days: 1))) &&
          date.isBefore(
            period.endDate.add(Duration(days: period.cycleLength)),
          )) {
        period.dailyData[date] = data;
        break;
      }
    }
    await _savePeriods(periods);
  }

  List<DateTime> predictNextPeriods(List<PeriodData> periods, int monthsAhead) {
    if (periods.isEmpty) return [];

    // Calculate average cycle length
    final cycleLengths = periods.map((p) => p.cycleLength).toList();
    final avgCycleLength =
        cycleLengths.reduce((a, b) => a + b) / cycleLengths.length;

    final lastPeriod = periods.last;
    final predictions = <DateTime>[];

    for (int i = 1; i <= monthsAhead; i++) {
      final nextPeriodDate = lastPeriod.startDate.add(
        Duration(days: (avgCycleLength * i).round()),
      );
      predictions.add(nextPeriodDate);
    }

    return predictions;
  }

  DateTime? predictOvulation(DateTime periodStart, int cycleLength) {
    // Ovulation typically occurs 14 days before next period
    return periodStart.add(Duration(days: cycleLength - 14));
  }

  CyclePhase getCurrentPhase(
    DateTime currentDate,
    DateTime lastPeriodStart,
    int cycleLength,
  ) {
    final daysSinceLastPeriod = currentDate.difference(lastPeriodStart).inDays;

    if (daysSinceLastPeriod <= 5) {
      return CyclePhase.menstruation;
    } else if (daysSinceLastPeriod <= cycleLength - 16) {
      return CyclePhase.follicular;
    } else if (daysSinceLastPeriod <= cycleLength - 12) {
      return CyclePhase.ovulation;
    } else {
      return CyclePhase.luteal;
    }
  }
}
