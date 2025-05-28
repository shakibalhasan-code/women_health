import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menstrual_cycle_widget/ui/graphs_view/menstrual_body_temperature_graph.dart';
import 'package:menstrual_cycle_widget/ui/graphs_view/menstrual_cycle_history_graph.dart';
import 'package:menstrual_cycle_widget/ui/graphs_view/menstrual_cycle_periods_graph.dart'
    show MenstrualCyclePeriodsGraph;
import 'package:menstrual_cycle_widget/ui/graphs_view/menstrual_cycle_trends_graph.dart';
import 'package:menstrual_cycle_widget/utils/enumeration.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr("analysis")),
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Body Temperature',
                  style: TextStyle(
                      backgroundColor: Colors.black, color: Colors.white),
                ),
                MenstrualBodyTemperatureGraph(
                  bodyTemperatureUnits: BodyTemperatureUnits.celsius,
                  isShowMoreOptions: false,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Cycle Trends',
                  style: TextStyle(
                      backgroundColor: Colors.black, color: Colors.white),
                ),
                MenstrualCycleTrendsGraph(
                  isShowMoreOptions: false,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Cycle Period',
                  style: TextStyle(
                      backgroundColor: Colors.black, color: Colors.white),
                ),
                MenstrualCyclePeriodsGraph(
                  isShowMoreOptions: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
