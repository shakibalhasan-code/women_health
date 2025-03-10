import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CounselorController extends GetxController {
  var counselors = List.generate(
    10,
    (index) => {
      'name': 'Dr. Rahat Karim',
      'image': 'https://example.com/counselor.jpg',
      'specialization': 'Relationship & Marriage Therapy',
    },
  ).obs;
}
