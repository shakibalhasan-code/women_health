import 'package:get/get.dart';
import 'package:menstrual_cycle_widget/database_helper/database_helper.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget_base.dart';

class PeriodDataController extends GetxController {
  final instance = MenstrualCycleWidget.instance!;
  final dbHelper = MenstrualCycleDbHelper.instance;

  @override
  void onInit() {
    // TODO: implement onInit
    instance.updateConfiguration(
        cycleLength: 28, periodDuration: 5, customerId: "1");
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    final allPeriodDetails = await instance.getTodaySymptomsLog();
    print(
        '=========================>>>>>>>>>>>>>>>>>>>>>>>>>>>> $allPeriodDetails');
  }
}
