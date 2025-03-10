import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:menstrual_cycle_widget/ui/menstrual_monthly_calender_view.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/utils/helper/widget_helper.dart';

class MonthlyScreen extends StatelessWidget {
  const MonthlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.showAppBar(
          title: 'Monthly Period Tracker', isBack: false),
      body: MenstrualCycleMonthlyCalenderView(
        themeColor: AppTheme.black400,
        hideInfoView: false,
        daySelectedColor: Colors.blue,
        onDataChanged: (value) {
          print(value);
        },
      ),
    );
  }
}
