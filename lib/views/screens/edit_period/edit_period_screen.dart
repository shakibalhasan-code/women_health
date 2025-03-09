import 'package:flutter/material.dart';
import 'package:menstrual_cycle_widget/ui/menstrual_log_period_view.dart';
import 'package:menstrual_cycle_widget/ui/model/display_symptoms_data.dart';

class EditPeriodScreen extends StatefulWidget {
  const EditPeriodScreen({super.key});

  @override
  State<EditPeriodScreen> createState() => _EditPeriodScreenState();
}

class _EditPeriodScreenState extends State<EditPeriodScreen> {

  late DateTime symptomsLogDate;

  @override
  void initState() {
    super.initState();
    symptomsLogDate = DateTime.now(); // Set initial date
  }

  void updateDate(DateTime newDate) {
    setState(() {
      symptomsLogDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MenstrualLogPeriodView(
      displaySymptomsData: DisplaySymptomsData(),
      symptomsLogDate: symptomsLogDate,
      // onDateChanged: updateDate, // Ensure onDateChanged updates the state
      onError: () {},
      onSuccess: (int id) {

      },
    );
  }
}
