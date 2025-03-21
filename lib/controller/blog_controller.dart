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
    await fetchAllCategories(); // 1. Fetch categories
    await fetchBlogData(); // 2. Then fetch blog data
  }

  // 🟢 1. Fetching all categories (from secured endpoint)
  Future<void> fetchAllCategories() async {
    try {
      final token = prefs?.getString('token');
      if (token == null) {
        print('Token not found');
        return;
      }

      final response = await http.get(
        Uri.parse(ApiEndpoints.allCategory),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> fetched = jsonData['categories'];

        final List<String> names =
            fetched.map((e) => e['name'].toString()).toList();
        categories.addAll(names); // starts with "All", then adds API names

        print("Categories: $categories");
      } else {
        print('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  // 🟢 2. Blog posts fetching (No token needed if public)
  Future<void> fetchBlogData() async {
    try {
      isLoading(true);

      final response = await http.get(Uri.parse(ApiEndpoints.blogPost));
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
