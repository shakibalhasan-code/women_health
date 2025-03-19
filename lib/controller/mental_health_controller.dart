import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/utils/constant/api_endpoints.dart';
import '../core/models/blog_model.dart';

// Controller
class MentalHealthController extends GetxController {
  RxString selectedCategory = "All".obs;
  RxList<BlogPostModel> posts = <BlogPostModel>[].obs; // Use the existing model
  RxBool isLoading = true.obs;

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

  // Declare this variable outside the try/catch block so it's accessible in the class
  SharedPreferences? prefs;

  @override
  void onInit() {
    super.onInit();
    initializeSharedPreferences();
    fetchMentalHealthData();
  }

  // Initialize SharedPreferences
  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> fetchMentalHealthData() async {
    try {
      isLoading(true);

      // Get token from shared preferences
      final token = prefs?.getString('token'); // Replace 'token' with the actual key you use to store the token

      // Check if token is available
      if (token == null) {
        print('No token found in shared preferences');
        isLoading(false); // Ensure loading is set to false
        return; // Exit the function if the token is not available
      }

      final response = await http.get(
        Uri.parse(ApiEndpoints.allMentalPost),
        headers: {
          'Authorization': 'Bearer $token', // Add the Authorization header
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> postsData = jsonResponse['posts']; // Access the "posts" array

        posts.value = postsData.map((item) => BlogPostModel.fromJson(item)).toList();
      } else {
        print('Failed to fetch mental health data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching mental health data: $e');
    } finally {
      isLoading(false);
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  List<BlogPostModel> getFilteredPosts() {
    if (selectedCategory.value == "All") {
      return posts;
    } else {
      return posts.where((post) => post.category?.name == selectedCategory.value).toList();
    }
  }
}