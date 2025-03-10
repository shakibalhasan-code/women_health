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
    return SafeArea(
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
              Text('Body Temperature'),
              MenstrualBodyTemperatureGraph(
                bodyTemperatureUnits: BodyTemperatureUnits.celsius,
                isShowMoreOptions: true,
                onPdfDownloadCallback: (pdfPath) async {
                  // This function will be called when the user downloads an pdf
                  // pdfPath contains the path to the downloaded pdf
                },
                onImageDownloadCallback: (imagePath) async {
                  // This function will be called when the user downloads an image
                  // imagePath contains the path to the downloaded image
                },
              ),
              SizedBox(height: 8.h),
              Text('Cycle Trends'),
              MenstrualCycleTrendsGraph(
                isShowMoreOptions: true,
                onPdfDownloadCallback: (pdfPath) async {
                  // This function will be called when the user downloads an pdf
                  // pdfPath contains the path to the downloaded pdf
                },
                onImageDownloadCallback: (imagePath) async {
                  // This function will be called when the user downloads an image
                  // imagePath contains the path to the downloaded image
                },
              ),
              SizedBox(height: 8.h),
              Text('Cycle Period'),
              MenstrualCyclePeriodsGraph(
                isShowMoreOptions: true,
                onPdfDownloadCallback: (pdfPath) async {
                  // This function will be called when the user downloads an pdf
                  // pdfPath contains the path to the downloaded pdf
                },
                onImageDownloadCallback: (imagePath) async {
                  // This function will be called when the user downloads an image
                  // imagePath contains the path to the downloaded image
                },
              ),
              Text('History'),
              MenstrualCycleHistoryGraph()
            ],
          ),
        ),
      ),
    );
  }
}
