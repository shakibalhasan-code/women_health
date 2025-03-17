import 'package:get/get.dart';

class CommunityController extends GetxController {
  var postCategory = [
    'All',
    'Period Care',
    'Mental Wellness',
    'Health Advice',
    'Hormonal Health',
    'Sexual Health',
    'Product Reviews',
    'Pregnancy',
    'Skin & Beauty'
  ].obs;

  var selectedCategory = 'All'.obs;

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  var isLikedPost = false.obs;
}
