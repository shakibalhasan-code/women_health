import 'package:get/get.dart';

class BlogController extends GetxController {
  var selectedCategory = "All".obs;

  final List<String> categories = [
    "All",
    "Mental Health",
    "Physical Wellness",
    "Nutrition",
    "Exercise",
    "Lifestyle",
    "Self-Care",
    "Mindfulness"
  ];

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
