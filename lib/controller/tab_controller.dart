import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:women_health/views/screens/analysis/analysis_screen.dart';
import 'package:women_health/views/screens/analysis/analytics_view.dart';
import 'package:women_health/views/screens/community/community_screen.dart';
import 'package:women_health/views/screens/home/home_screen.dart';
import 'package:women_health/views/screens/monthly/calender_screen.dart';
import 'package:women_health/views/screens/monthly/monthly_screen.dart';
import 'package:women_health/views/screens/profile/profile_screen.dart';

class MyTabController extends GetxController {
  var currentIndex = 0.obs;

  RxList<Widget> screen = [
    HomeScreen(),
    CalendarScreen(),
    CommunityScreen(),
    AnalyticsScreen(),
    ProfileScreen()
  ].obs;

  void changeTab(int index) async {
    currentIndex.value = index;
  }
}
