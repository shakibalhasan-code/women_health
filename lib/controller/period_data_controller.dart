import 'package:get/get.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget_base.dart';

class PeriodDataController extends GetxController{

  final instance = MenstrualCycleWidget.instance!;



  @override
  void onInit() {
    // TODO: implement onInit
    instance.updateConfiguration(cycleLength: 28, periodDuration: 5, customerId: "1");
    super.onInit();
  }

}