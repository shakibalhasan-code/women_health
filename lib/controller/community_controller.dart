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

  var matchedUsers = <Map<String, String>>[
    {'name': 'Happy', 'image': 'https://example.com/happy.jpg'},
    {'name': 'Jolekha', 'image': 'https://example.com/jolekha.jpg'},
    {'name': 'Akhi', 'image': 'https://example.com/akhi.jpg'},
    {'name': 'Ema', 'image': 'https://example.com/ema.jpg'},
  ].obs;

  var followedUsers = <Map<String, String>>[
    {'name': 'Happy', 'image': 'https://example.com/happy.jpg'},
    {'name': 'Jolekha', 'image': 'https://example.com/jolekha.jpg'},
    {'name': 'Akhi', 'image': 'https://example.com/akhi.jpg'},
    {'name': 'Ema', 'image': 'https://example.com/ema.jpg'},
  ].obs;

  var allMatchedUsers = List.generate(
    10,
    (index) => {
      'name': 'Elena Sheikh',
      'image': 'https://example.com/elena.jpg',
    },
  ).obs;
}
