import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/core/models/period_data.dart';
import 'package:women_health/core/services/period_services.dart';

class PeriodController extends GetxController {
  static const String calendarUpdateId = 'calendar-update-id';
  final PeriodService _periodService = PeriodService();

  // --- REACTIVE STATE VARIABLES ---
  final RxBool isLoading = true.obs;
  final RxList<PeriodData> allPeriods = <PeriodData>[].obs;
  final Rx<PeriodData?> lastPeriod = Rx<PeriodData?>(null);
  final RxInt averagePeriodDuration = 5.obs;
  final RxInt averageCycleLength = 28.obs;
  final Rx<CyclePhase> currentPhase = CyclePhase.follicular.obs;
  final RxInt currentDayOfCycle = 1.obs;
  final RxList<DateTime> nextPredictedPeriods = <DateTime>[].obs;
  final RxList<DateTime> allOvulationDates = <DateTime>[].obs;

  @override
  void onInit() {
    super.onInit();
    // This loads data if it already exists. Initialization is handled from main.dart.
    loadPeriodData();
  }

  /// Special function to create the first period entry from user's onboarding answers.
  Future<void> initializeFromOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    final responsesJson = prefs.getString('userResponses');
    if (responsesJson == null) {
      debugPrint("Error: Called initialize but no 'userResponses' found in SharedPreferences.");
      return;
    }

    try {
      final Map<String, dynamic> responses = jsonDecode(responsesJson);

      final String lastPeriodStr = responses['When was your last period?'];
      final String periodDurationStr = responses['How long does your period usually last?'];
      final String cycleLengthStr = responses['How regular is your menstrual cycle?'];

      final DateTime lastPeriodDate = DateTime.parse(lastPeriodStr);
      final int periodDuration = _parsePeriodDuration(periodDurationStr);
      final int cycleLength = _parseCycleLength(cycleLengthStr);

      final firstPeriod = PeriodData(
        startDate: lastPeriodDate,
        endDate: lastPeriodDate.add(Duration(days: periodDuration - 1)),
        cycleLength: cycleLength,
      );

      await _periodService.savePeriod(firstPeriod);
      debugPrint("Successfully created and saved the first period entry.");

      // Now, load all data into the controller to update the UI.
      await loadPeriodData();

    } catch (e, stackTrace) {
      debugPrint("Failed to parse onboarding data or create first period: $e");
      debugPrint("Stack trace: $stackTrace");
    }
  }

  /// Loads all period data from storage and updates calculations.
  Future<void> loadPeriodData() async {
    isLoading.value = true;
    final periods = await _periodService.getPeriods();
    if (periods.isNotEmpty) {
      periods.sort((a, b) => b.startDate.compareTo(a.startDate));
      allPeriods.assignAll(periods);
      lastPeriod.value = allPeriods.first;
      _updateCalculations();
    }
    isLoading.value = false;
    update([calendarUpdateId]); // Notify calendar to rebuild.
  }

  /// Logs a new period and smartly calculates the previous cycle's actual length.
  Future<void> logNewPeriod(DateTime startDate) async {
    if (lastPeriod.value != null) {
      // This is the magic: calculate the true length of the cycle that just ended.
      final previousCycleLength = startDate.difference(lastPeriod.value!.startDate).inDays;
      final updatedLastPeriod = PeriodData(
        startDate: lastPeriod.value!.startDate,
        endDate: lastPeriod.value!.endDate,
        cycleLength: previousCycleLength,
        dailyData: lastPeriod.value!.dailyData,
      );
      allPeriods[0] = updatedLastPeriod;
    }

    final newPeriod = PeriodData(
      startDate: startDate,
      endDate: startDate.add(Duration(days: averagePeriodDuration.value - 1)),
      cycleLength: averageCycleLength.value, // Use average as placeholder for the current cycle
    );

    allPeriods.insert(0, newPeriod);
    await _periodService.saveAllPeriods(allPeriods);
    await loadPeriodData(); // Reload and recalculate everything
  }

  /// Saves a user's daily log (symptoms, mood, etc.).
  Future<void> updateDailyLog(DateTime date, DailyData data) async {
    await _periodService.updateDailyData(date, data);
    await loadPeriodData(); // Simple reload for now, can be optimized later
  }

  /// Helper to get daily data for a specific date to show in the UI.
  DailyData? getDailyDataFor(DateTime date) {
    final dateKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    for (final period in allPeriods) {
      if (period.dailyData.containsKey(dateKey)) {
        return period.dailyData[dateKey];
      }
    }
    return null;
  }

  // --- PRIVATE HELPERS ---

  /// Updates all calculated values like averages, predictions, and current phase.
  void _updateCalculations() {
    if (allPeriods.isEmpty) return;

    // 1. Calculate Averages
    final completedCycles = allPeriods.where((p) => p.cycleLength > 0).toList();
    if (completedCycles.length > 1) {
      final sum = completedCycles.sublist(1).map((p) => p.cycleLength).reduce((a, b) => a + b);
      averageCycleLength.value = (sum / (completedCycles.length - 1)).round();
    } else if (completedCycles.isNotEmpty) {
      averageCycleLength.value = completedCycles.first.cycleLength;
    }

    final sumDuration = allPeriods.map((p) => p.endDate.difference(p.startDate).inDays + 1).reduce((a, b) => a + b);
    averagePeriodDuration.value = (sumDuration / allPeriods.length).round();

    // 2. Calculate Current Day and Phase
    currentDayOfCycle.value = DateTime.now().difference(lastPeriod.value!.startDate).inDays + 1;
    currentPhase.value = _periodService.getCurrentPhase(
        DateTime.now(), lastPeriod.value!.startDate, averageCycleLength.value,
        menstruationLength: averagePeriodDuration.value);

    // 3. Recalculate all predictions
    _recalculatePredictions();
  }

  void _recalculatePredictions() {
    nextPredictedPeriods.value = _periodService.predictNextPeriods(allPeriods, 6);
    final ovulationDates = <DateTime>[];
    for (var period in allPeriods) {
      final ovulation = _periodService.predictOvulation(period.startDate, period.cycleLength);
      if (ovulation != null) ovulationDates.add(ovulation);
    }
    for (var predictedPeriodStart in nextPredictedPeriods) {
      final ovulation = _periodService.predictOvulation(predictedPeriodStart, averageCycleLength.value);
      if (ovulation != null) ovulationDates.add(ovulation);
    }
    allOvulationDates.value = ovulationDates;
  }

  int _parsePeriodDuration(String input) {
    final RegExp numRegExp = RegExp(r'\d+');
    final matches = numRegExp.allMatches(input);
    if (matches.isNotEmpty) return int.parse(matches.last.group(0)!);
    return 5;
  }

  int _parseCycleLength(String input) {
    final RegExp numRegExp = RegExp(r'\d+');
    final matches = numRegExp.allMatches(input);
    if (matches.isNotEmpty) return int.parse(matches.first.group(0)!);
    return 28;
  }
}