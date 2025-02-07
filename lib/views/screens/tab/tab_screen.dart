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

    return Scaffold(
      body: Obx(()=> _tabController.screen[_tabController.currentIndex.value]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.defaultRadius),)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          child: GNav(
            activeColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            color: Colors.grey,
            tabBackgroundColor:AppTheme.primaryColor,
            rippleColor: AppTheme.primaryColor,
            gap: 5,
            style: GnavStyle.google,
            onTabChange: (index){
              _tabController.changeTab(index);
            },
              tabs: [
                buildGButton(Icons.home_filled, 'Home'),
                buildGButton(Icons.calendar_month_rounded, 'Calender'),
                buildGButton(Icons.group, 'Community'),
                buildGButton(Icons.analytics_rounded, 'Analysis'),
                buildGButton(Icons.person, 'Profile'),
              ],
            selectedIndex: _tabController.currentIndex.value,

          ),
        ),
      ),
    );
  }


  GButton buildGButton(IconData icon, String label) => GButton(
    icon: icon,
    text: label,style: GnavStyle.google, // If your GButton supports text
    // ... other GButton properties
  );
}
