import 'package:get/get.dart';
import 'package:women_health/controller/auth_controller.dart';
import 'package:women_health/controller/community_controller.dart';
import 'package:women_health/controller/intro_controller/intro_controller.dart';
import 'package:women_health/controller/marketplace_controller.dart';
import 'package:women_health/controller/period_data_controller.dart';
import 'package:women_health/controller/tab_controller.dart';
import 'package:women_health/core/helper/user_info_helper.dart';

import '../../controller/intro_controller/payment_controller.dart';
import '../../controller/profile_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => QuestionnaireController(),fenix: true);
    Get.lazyPut(() => MyTabController(),fenix: true);
    Get.lazyPut(() => UserHelper(),fenix: true);
    Get.lazyPut(() => PeriodDataController(),fenix: true);
    Get.lazyPut(() => MarketplaceController(), fenix: true);
    Get.lazyPut(()=> CommunityController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => PaymentController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
  }
}
