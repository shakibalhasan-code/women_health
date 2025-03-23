import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/utils/constant/api_endpoints.dart';
import '../core/models/blog_model.dart';

class MentalHealthController extends GetxController {
  RxString selectedCategory = "All".obs;
  RxList<BlogPostModel> posts = <BlogPostModel>[].obs;
  RxList<String> categories = <String>["All"].obs;
  RxBool isLoading = true.obs;

  SharedPreferences? prefs;

  @override
  void onInit() {
    super.onInit();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await fetchCategories();
    await fetchMentalHealthData();
  }

  Future<void> fetchCategories() async {
    try {
      final token = prefs?.getString('token');
      if (token == null) {
        print('No token found for categories');
        return;
      }

      final response = await http.get(
        Uri.parse(ApiEndpoints.allCategory), // Make sure this is correct
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> categoryList = jsonData['categories'];
        final List<String> fetchedNames =
            categoryList.map((e) => e['name'].toString()).toList();

        categories.addAll(fetchedNames);
      } else {
        print('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchMentalHealthData() async {
    try {
      isLoading(true);
      final token = prefs?.getString('token');
      if (token == null) {
        print('No token found for categories');
        return;
      }

      final response = await http.get(Uri.parse(ApiEndpoints.allMentalPost),headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> postsData = jsonResponse['posts'];
        posts.value =
            postsData.map((item) => BlogPostModel.fromJson(item)).toList();
      } else {
        print('Failed to fetch mental health posts: ${response.statusCode}');
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
      return posts
          .where((post) => post.category?.name == selectedCategory.value)
          .toList();
    }
  }

  String getFullImageUrl(String imagePath) {
    return '${ApiEndpoints.url}$imagePath';
  }
}
