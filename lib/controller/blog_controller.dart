import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/utils/constant/api_endpoints.dart';

import '../core/models/blog_model.dart';

// Controller
class BlogController extends GetxController {
  RxList<String> categories = <String>[].obs;
  RxString selectedCategory = ''.obs;
  RxList<BlogPostModel> blogPosts = <BlogPostModel>[].obs;
  RxBool isLoading = true.obs;

  SharedPreferences? prefs;

  @override
  void onInit() {
    super.onInit();
    initializeSharedPreferences();
    fetchBlogData();
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> fetchBlogData() async {
    try {
      isLoading(true);

      final token = prefs?.getString('token');

      if (token == null) {
        print('No token found in shared preferences');
        isLoading(false);
        return;
      }
      print(token);

      final response = await http.get(
        Uri.parse(ApiEndpoints.blogPost),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        blogPosts.value = jsonResponse.map((item) => BlogPostModel.fromJson(item)).toList();

        Set<String> uniqueCategories = {};
        for (var post in blogPosts) {
          if (post.category != null && post.category!.name != null) {
            uniqueCategories.add(post.category!.name!);
          }
        }
        categories.value = uniqueCategories.toList();
        if (categories.isNotEmpty) {
          selectedCategory.value = categories.first;
        }
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
    if (selectedCategory.value.isEmpty) {
      return blogPosts;
    } else {
      return blogPosts.where((post) => post.category?.name == selectedCategory.value).toList();
    }
  }
}