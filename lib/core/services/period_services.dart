import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/core/models/period_data.dart';

class PeriodService {
  static const String _periodsKey = 'periods_data';

  Future<List<PeriodData>> getPeriods() async {
    final prefs = await SharedPreferences.getInstance();
    // No mock data!
    final periodsJson = prefs.getStringList(_periodsKey) ?? [];
    return periodsJson
        .map((json) => PeriodData.fromJson(jsonDecode(json)))
        .toList();
  }

  // Changed to save the whole list at once for consistency
  Future<void> saveAllPeriods(List<PeriodData> periods) async {
    final prefs = await SharedPreferences.getInstance();
    final periodsJson =
    periods.map((period) => jsonEncode(period.toJson())).toList();
    await prefs.setStringList(_periodsKey, periodsJson);
  }

  // A single save is still useful for the first-time setup
  Future<void> savePeriod(PeriodData period) async {
    final periods = await getPeriods();
    periods.add(period);
    await saveAllPeriods(periods);
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_periodsKey);
  }

  Future<void> updateDailyData(DateTime date, DailyData data) async {
    // This logic is a bit complex, might need optimization based on how many periods you store
    final periods = await getPeriods();
    bool updated = false;
    for (var period in periods) {
      // Find the cycle this date belongs to
      final cycleEndDate = period.startDate.add(Duration(days: period.cycleLength));
      if (!date.isBefore(period.startDate) && date.isBefore(cycleEndDate)) {
        period.dailyData[date.toIso8601String()] = data; // Use string key for JSON
        updated = true;
        break;
      }
    }
    if (updated) {
      await saveAllPeriods(periods);
    }
  }

  // --- Calculation Logic (Pure Functions) ---

  List<DateTime> predictNextPeriods(List<PeriodData> periods, int monthsAhead) {
    if (periods.isEmpty) return [];

    final lastPeriod = periods.first; // Assumes list is sorted descending
    final cycleLengths = periods
        .where((p) => p.cycleLength > 0)
        .map((p) => p.cycleLength)
        .toList();

    if (cycleLengths.isEmpty) return []; // Cannot predict without history

    final avgCycleLength =
        cycleLengths.reduce((a, b) => a + b) / cycleLengths.length;

    final predictions = <DateTime>[];
    DateTime lastKnownStart = lastPeriod.startDate;

    for (int i = 1; i <= monthsAhead; i++) {
      final nextPeriodDate = lastKnownStart.add(
        Duration(days: (avgCycleLength * i).round()),
      );
      predictions.add(nextPeriodDate);
    }
    return predictions;
  }

  DateTime? predictOvulation(DateTime periodStart, int cycleLength) {
    if (cycleLength <= 0) return null;
    // Ovulation typically occurs 14 days before the *next* period.
    return periodStart.add(Duration(days: cycleLength - 14));
  }

  CyclePhase getCurrentPhase(
      DateTime currentDate,
      DateTime lastPeriodStart,
      int cycleLength,
      {int menstruationLength = 5} // Allow customizing this
      ) {
    final daysSinceLastPeriod = currentDate.difference(lastPeriodStart).inDays;

    // Ensure we don't go into negative days if clock is off
    if (daysSinceLastPeriod < 0) return CyclePhase.follicular;

    final ovulationDay = cycleLength - 14;

    if (daysSinceLastPeriod <= menstruationLength) {
      return CyclePhase.menstruation;
    } else if (daysSinceLastPeriod < ovulationDay - 2) { // Fertile window starts a few days before
      return CyclePhase.follicular;
    } else if (daysSinceLastPeriod <= ovulationDay + 2) { // Ovulation/Fertile Window
      return CyclePhase.ovulation;
    } else {
      return CyclePhase.luteal;
    }
  }
}