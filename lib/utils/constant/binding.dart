import 'package:get/get.dart';
import 'package:women_health/controller/intro_controller/intro_controller.dart';
import 'package:women_health/controller/period_data_controller.dart';
import 'package:women_health/controller/tab_controller.dart';
import 'package:women_health/core/helper/user_info_helper.dart';

class InitialBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>IntroController());
    Get.lazyPut(()=> MyTabController());
    Get.lazyPut(()=> UserHelper());
    Get.lazyPut(()=> PeriodDataController());
  }

}