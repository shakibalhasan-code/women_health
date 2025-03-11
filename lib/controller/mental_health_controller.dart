import 'package:get/get.dart';

class MentalHealthController extends GetxController {
  var selectedCategory = "All".obs;

  final List<String> categories = [
    "All",
    "Period Care",
    "Mental Wellness",
    "Health Advice",
    "Sexual Health",
    "Product Reviews",
    "Pregnancy",
    "Skin & Beauty"
  ];

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
