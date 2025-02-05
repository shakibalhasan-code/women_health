import 'package:get/get.dart';
import 'package:women_health/controller/intro_controller/intro_controller.dart';

class InitialBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>IntroController());
  }

}