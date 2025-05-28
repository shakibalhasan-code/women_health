import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:women_health/controller/tab_controller.dart';
import 'package:women_health/utils/constant/app_icons.dart';
import 'package:women_health/utils/constant/app_theme.dart';

class TabScreen extends StatelessWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _tabController = Get.find<MyTabController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      body: Obx(() => _tabController.screen[_tabController.currentIndex.value]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.defaultRadius),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GNav(
            gap: isSmallScreen ? 3 : 8,
            activeColor: Colors.white,
            color: Colors.grey,
            tabBackgroundColor: AppTheme.primaryColor,
            rippleColor: AppTheme.primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8 : 15,
              vertical: isSmallScreen ? 8 : 10,
            ),
            onTabChange: _tabController.changeTab,
            selectedIndex: _tabController.currentIndex.value,
            tabs: [
              buildGButton(Icons.home_filled, 'Home', isSmallScreen),
              buildGButton(
                  Icons.calendar_month_rounded, 'Calendar', isSmallScreen),
              buildGButton(Icons.group, 'Community', isSmallScreen),
              buildGButton(Icons.analytics_rounded, 'Analysis', isSmallScreen),
              buildGButton(Icons.person, 'Profile', isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  GButton buildGButton(IconData icon, String label, bool isSmallScreen) {
    return GButton(
      icon: icon,
      text: isSmallScreen ? '' : label,
      iconSize: isSmallScreen ? 20 : 24,
      textStyle: TextStyle(
          fontSize: isSmallScreen ? 10 : 14,
          fontWeight: FontWeight.w500,
          color: Colors.white),
    );
  }
}
