import 'package:get/get.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget_base.dart';

class UserHelper extends GetxService {

  var lastPeriodDate = ''.obs;
  var periodDuration = 5.obs;
  var cycleLength = 28.obs;

  var completedQuestion = 1.obs;
  final instance = MenstrualCycleWidget.instance!;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    instance.updateConfiguration(cycleLength: cycleLength.value, periodDuration: periodDuration.value, customerId: "1");
  }


  void incrementStep() {
    if (completedQuestion < 10) {
      completedQuestion.value ++;
    }
  }

  void decrementStep() {
    if (completedQuestion.value > 1) {
      completedQuestion.value --;
    }
  }


}