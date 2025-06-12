import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/utils/constant/app_icons.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/views/screens/blog/blog_screen.dart';
import 'package:women_health/views/screens/community/community_screen.dart';
import 'package:women_health/views/screens/home/components/home_card_widget.dart';
// --- NEW IMPORT FOR THE CHART WIDGET ---
import 'package:women_health/views/screens/home/components/menstrual_cycle_chart.dart'
    show MenstrualCycleChart, CyclePhase;
import 'package:women_health/views/screens/marketplace/marketplace_screen.dart';
import 'package:women_health/views/screens/mental_health_couns/mental_health_counselor.dart';
// --- PLACEHOLDER CLASSES & ENUMS (Kept for this file to be self-contained) ---
// In a real app, these would be in their own model/service files.

// REMOVE enum CyclePhase HERE, use the shared one from menstrual_cycle_chart.dart
// REMOVE enum CyclePhase HERE, use the shared one from menstrual_cycle_chart.dart
// enum CyclePhase { menstruation, follicular, ovulation, luteal }
class PeriodData {
  final DateTime startDate;
  final DateTime endDate;
  final int cycleLength;

  PeriodData({
    required this.startDate,
    required this.endDate,
    required this.cycleLength,
  });
}

class PeriodService {
  Future<List<PeriodData>> getPeriods() async {
    // Mock implementation: In a real app, this would fetch data from a database.
    await Future.delayed(const Duration(milliseconds: 100));
    // Example: A user who started their last period 12 days ago with a 31-day cycle
    return [
      PeriodData(
          startDate: DateTime.now().subtract(const Duration(days: 12)),
          endDate: DateTime.now().subtract(const Duration(days: 7)),
          cycleLength: 31),
      PeriodData(
          startDate: DateTime.now().subtract(const Duration(days: 42)),
          endDate: DateTime.now().subtract(const Duration(days: 37)),
          cycleLength: 30),
    ];
  }

  // This logic is now a bit simplified, as the chart itself handles phase display
  // But it's still useful for the "Current Phase" card.
  CyclePhase getCurrentPhase(
      DateTime now, DateTime lastPeriodStart, int cycleLength) {
    int dayOfCycle = now.difference(lastPeriodStart).inDays + 1;
    if (dayOfCycle <= 5) return CyclePhase.menstruation;
    // Note: The fertile window can overlap follicular and ovulation.
    // We'll define ovulation as a few key days for simplicity here.
    if (dayOfCycle >= 14 && dayOfCycle <= 19) return CyclePhase.ovulation;
    if (dayOfCycle < 14) return CyclePhase.follicular;
    return CyclePhase.luteal;
  }

  Future<void> savePeriod(PeriodData period) async {
    // Mock implementation: In a real app, this would save data to a database.
    debugPrint("Period logged for ${period.startDate}");
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

// --- The old MenstrualCycleWidget has been removed as it's replaced by MenstrualCycleChart ---

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PeriodService _periodService = PeriodService();
  List<PeriodData> _periods = [];
  CyclePhase _currentPhase = CyclePhase.follicular;
  DateTime? _lastPeriodStart;
  int _averageCycleLength = 28; // Default value

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final periods = await _periodService.getPeriods();
    if (periods.isNotEmpty) {
      periods.sort(
          (a, b) => b.startDate.compareTo(a.startDate)); // Sort descending

      final lastPeriod = periods.first;
      final avgLength = periods.map((p) => p.cycleLength).isNotEmpty
          ? periods.map((p) => p.cycleLength).reduce((a, b) => a + b) ~/
              periods.length
          : 28; // fallback to default

      setState(() {
        _periods = periods;
        _lastPeriodStart = lastPeriod.startDate;
        _averageCycleLength = avgLength;
        _currentPhase = _periodService.getCurrentPhase(
          DateTime.now(),
          _lastPeriodStart!,
          _averageCycleLength,
        );
      });
    } else {
      // Handle case where there is no data at all
      setState(() {
        _lastPeriodStart = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // --- WIDGET REPLACEMENT AREA ---
              // The old card is replaced with this new logic block.

              if (_lastPeriodStart == null)
                // Show a placeholder if there is no data yet
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Container(
                    height:
                        300.h, // Give it a fixed height to avoid layout jumps
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20.w),
                    child: Text(
                      'Log your first period to see your cycle.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                // Show the chart if data is available
                MenstrualCycleChart(
                  cycleLength: _averageCycleLength,
                  // Calculate the current day. Add 1 because difference can be 0.
                  currentDayOfCycle:
                      DateTime.now().difference(_lastPeriodStart!).inDays + 1,
                  currentPhase: _currentPhase,
                  // These can be made dynamic later from user settings
                  menstruationLength: 5,
                  ovulationStartDay: 14,
                ),

              SizedBox(height: 20.h),

              // Quick Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context.tr('current_phase'),
                      _getPhaseText(_currentPhase),
                      _getPhaseColor(_currentPhase),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildStatCard(
                      context.tr('cycle_length'),
                      '$_averageCycleLength days',
                      Colors.blue.shade400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Next Period Prediction
              if (_lastPeriodStart != null)
                Card(
                  child: ListTile(
                    leading: Icon(Icons.calendar_today,
                        color: AppTheme.primaryColor),
                    title: Text(context.tr('next_period')),
                    subtitle: Text(_getNextPeriodText()),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),

              SizedBox(height: 20.h),

              // Log Period Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showLogPeriodDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    context.tr('log_period'),
                    style: AppTheme.titleMedium.copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Grid Cards from the original snippet
              _buildGridCards(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Nirbhoya',
        style: AppTheme.titleLarge,
      ),
      centerTitle: true,
      leading: const SizedBox(),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildGridCards(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => Get.to(() => CommunityScreen(isBack: true)),
                child: HomeCardWidget(
                  iconPath: AppIcons.communityIcon,
                  title: context.tr('community_forum'),
                  subTitle: context.tr('community_forum_sub'),
                  cardColor: Colors.blue.withOpacity(0.1),
                  borderColor: AppTheme.blue,
                  iconColor: AppTheme.blue,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InkWell(
                onTap: () => Get.to(() => MarketplaceScreen()),
                child: HomeCardWidget(
                  iconPath: AppIcons.shopIcon,
                  title: context.tr('shopping'),
                  subTitle: context.tr('shopping_sub'),
                  cardColor: AppTheme.primaryColor.withOpacity(0.2),
                  borderColor: AppTheme.primaryColor,
                  iconColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => Get.to(() => MentalHealthScreen()),
                child: HomeCardWidget(
                  iconPath: AppIcons.mentalHealthIcon,
                  title: context.tr('mental_health'),
                  subTitle: context.tr('mental_health_sub'),
                  cardColor: AppTheme.yelloward,
                  borderColor: Colors.yellow,
                  iconColor: Colors.yellow,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InkWell(
                onTap: () => Get.to(() => BlogScreen()),
                child: HomeCardWidget(
                  iconPath: AppIcons.newsIcon,
                  title: context.tr('blog'),
                  subTitle: context.tr('blog_sub'),
                  cardColor: AppTheme.greenCard,
                  borderColor: Colors.green,
                  iconColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(
              title,
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: AppTheme.titleMedium
                  .copyWith(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  String _getPhaseText(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstruation:
        return context.tr('menstruation');
      case CyclePhase.follicular:
        return context.tr('follicular');
      case CyclePhase.ovulation:
        return context.tr('ovulation');
      case CyclePhase.luteal:
        return context.tr('luteal');
    }
  }

  Color _getPhaseColor(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstruation:
        return const Color(0xfff26b77); // Red from chart
      case CyclePhase.follicular:
        return const Color(0xfffce3e4); // Light Pink from chart
      case CyclePhase.ovulation:
        return const Color(0xff70c9ba); // Green from chart
      case CyclePhase.luteal:
        return const Color(0xffdbebf0); // Light Blue from chart
    }
  }

  String _getNextPeriodText() {
    if (_lastPeriodStart == null) return context.tr('no_data_available');

    final nextPeriod = _lastPeriodStart!.add(
      Duration(days: _averageCycleLength),
    );
    final daysUntil = nextPeriod.difference(DateTime.now()).inDays;

    if (daysUntil < 0) {
      return context.tr('period_is_late');
    }
    if (daysUntil == 0) {
      return context.tr('period_starts_today');
    }
    return context.tr('in_x_days', args: [daysUntil.toString()]);
  }

  void _showLogPeriodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('log_period')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.tr('log_period_confirm')),
            SizedBox(height: 16.h),
            Text(
              DateFormat.yMMMd().format(DateTime.now()),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              _logPeriod();
              Navigator.pop(context);
            },
            child: Text(context.tr('log_period')),
          ),
        ],
      ),
    );
  }

  void _logPeriod() async {
    final newPeriod = PeriodData(
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 5)), // Default 5 days
      // A more robust app would calculate this based on the last two periods.
      cycleLength: _averageCycleLength,
    );

    await _periodService.savePeriod(newPeriod);
    _loadData(); // Reload data to reflect the new entry

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('period_logged_success'))),
      );
    }
  }
}
