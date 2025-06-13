import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/views/screens/home/components/menstrual_cycle_chart.dart';
import 'package:women_health/views/screens/monthly/calender_screen.dart';
import 'package:women_health/utils/constant/app_icons.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/views/screens/blog/blog_screen.dart';
import 'package:women_health/views/screens/community/community_screen.dart';
import 'package:women_health/views/screens/marketplace/marketplace_screen.dart';
import 'package:women_health/views/screens/mental_health_couns/mental_health_counselor.dart';
import '../../../controller/period_data_controller.dart';
import 'components/home_card_widget.dart';

// A simple data model for our grid items to make the code cleaner.
class HomeGridItem {
  final String iconPath;
  final String title;
  final String subtitle;
  final Color cardColor;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onTap;

  HomeGridItem({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.cardColor,
    required this.borderColor,
    required this.iconColor,
    required this.onTap,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the controller instance that was created in main.dart
    final PeriodController controller = Get.find<PeriodController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nirbhoya'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Use a consistent padding for the whole screen
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            children: [
              // This Obx widget will react to changes in the controller's data
              Obx(() {
                if (controller.isLoading.value) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (controller.lastPeriod.value == null) {
                  return const Card(
                    child: SizedBox(
                      height: 300,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Welcome! Please complete onboarding to see your cycle predictions.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                // --- RESPONSIVE CHART ---
                // Use a LayoutBuilder to constrain the chart's size on large screens.
                return LayoutBuilder(
                  builder: (context, constraints) {
                    // Make the chart take up the full width, but not more than 400 logical pixels.
                    final double chartSize = constraints.maxWidth < 400 ? constraints.maxWidth : 400;
                    return Center(
                      child: SizedBox(
                        width: chartSize,
                        child: MenstrualCycleChart(
                          cycleLength: controller.averageCycleLength.value,
                          currentDayOfCycle: controller.currentDayOfCycle.value,
                          currentPhase: controller.currentPhase.value,
                          menstruationLength: controller.averagePeriodDuration.value,
                          ovulationStartDay: controller.averageCycleLength.value - 14,
                        ),
                      ),
                    );
                  },
                );
              }),
              SizedBox(height: 20.h),

              // Button to navigate to the full calendar
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('View Full Calendar & Log Data'),
                  onPressed: () => Get.to(() => const CalendarScreen()),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Your other grid cards can go here
              _buildGridCards(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the responsive grid of feature cards.
  Widget _buildGridCards(BuildContext context) {
    // Define the list of items for the grid. This keeps the layout logic clean.
    final List<HomeGridItem> gridItems = [
      HomeGridItem(
        iconPath: AppIcons.communityIcon,
        title: context.tr('community_forum'),
        subtitle: context.tr('community_forum_sub'),
        cardColor: Colors.blue.withOpacity(0.1),
        borderColor: AppTheme.blue,
        iconColor: AppTheme.blue,
        onTap: () => Get.to(() => CommunityScreen(isBack: true)),
      ),
      HomeGridItem(
        iconPath: AppIcons.shopIcon,
        title: context.tr('shopping'),
        subtitle: context.tr('shopping_sub'),
        cardColor: AppTheme.primaryColor.withOpacity(0.2),
        borderColor: AppTheme.primaryColor,
        iconColor: Colors.black,
        onTap: () => Get.to(() =>  MarketplaceScreen()),
      ),
      HomeGridItem(
        iconPath: AppIcons.mentalHealthIcon,
        title: context.tr('mental_health'),
        subtitle: context.tr('mental_health_sub'),
        cardColor: AppTheme.yelloward,
        borderColor: Colors.yellow,
        iconColor: Colors.yellow,
        onTap: () => Get.to(() =>  MentalHealthScreen()),
      ),
      HomeGridItem(
        iconPath: AppIcons.newsIcon,
        title: context.tr('blog'),
        subtitle: context.tr('blog_sub'),
        cardColor: AppTheme.greenCard,
        borderColor: Colors.green,
        iconColor: Colors.green,
        onTap: () => Get.to(() =>  BlogScreen()),
      ),
    ];

    // --- RESPONSIVE GRID ---
    // Use GridView.builder with SliverGridDelegateWithFixedCrossAxisCount.
    // This is more efficient and flexible than a fixed Row/Column layout.
    return GridView.builder(
      // Important: Tell the GridView not to scroll and to shrink to fit its content.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Always show 2 columns.
        crossAxisSpacing: 10.w, // Spacing between columns
        mainAxisSpacing: 10.h,   // Spacing between rows
        childAspectRatio: 1.1, // Adjust this ratio to make cards taller or shorter
      ),
      itemCount: gridItems.length,
      itemBuilder: (context, index) {
        final item = gridItems[index];
        return InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(16.r), // Match card's border radius
          child: HomeCardWidget(
            iconPath: item.iconPath,
            title: item.title,
            subTitle: item.subtitle,
            cardColor: item.cardColor,
            borderColor: item.borderColor,
            iconColor: item.iconColor,
          ),
        );
      },
    );
  }
}