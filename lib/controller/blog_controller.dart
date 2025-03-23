import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/utils/constant/api_endpoints.dart';
import '../core/models/blog_model.dart';

// Controller
class BlogController extends GetxController {
  RxList<String> categories = <String>["All"].obs;
  RxString selectedCategory = "All".obs;
  RxList<BlogPostModel> blogPosts = <BlogPostModel>[].obs;
  RxBool isLoading = true.obs;

  SharedPreferences? prefs;

  @override
  void onInit() {
    super.onInit();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await fetchCategories(); // 1. Fetch categories
    await fetchBlogData(); // 2. Then fetch blog data
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 🟢 1. Fetching all categories (from secured endpoint)
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

  // 🟢 2. Blog posts fetching (No token needed if public)
  Future<void> fetchBlogData() async {
    try {
      isLoading(true);

      final token = prefs?.getString('token');
      if (token == null) {
        print('No token found for categories');
        return;
      }

      final response = await http.get(Uri.parse(ApiEndpoints.blogPost), headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> postList = jsonData['posts'];

        blogPosts.value =
            postList.map((item) => BlogPostModel.fromJson(item)).toList();
      } else {
        print('Failed to fetch blog posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching blog posts: $e');
    } finally {
      isLoading(false);
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  List<BlogPostModel> getFilteredPosts() {
    if (selectedCategory.value == "All") {
      return blogPosts;
    } else {
      return blogPosts
          .where((post) => post.category?.name == selectedCategory.value)
          .toList();
    }
  }
}
