import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/product_model.dart';
import '../core/services/api_services.dart';
import 'package:http/http.dart' as http;
import '../utils/constant/api_endpoints.dart';

class MarketplaceController extends GetxController {
  var productCategories = <String>['Test1', 'Test2', 'Test3', 'Test4', 'Test5']
      .obs;
  SharedPreferences? prefs;
  RxList<String> categories = <String>["All"].obs;
  RxString selectedCategory = "All".obs; // Track selected category name
  var selectedCategoryIndex = 0.obs;
  var allProducts = <Product>[].obs; // Store all products fetched
  var products = <Product>[].obs; // Observable list of products for display
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories(); // Fetch categories first
    fetchProducts(); // Then fetch products (can depend on categories if needed)
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getAllProducts(); // Use your API service
      if (response != null) {
        allProducts.value = response.products; // Store all products
        filterProductsByCategory(selectedCategory.value); // Initial filter
      } else {
        Get.snackbar('Error', 'Failed to load products');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      prefs = await SharedPreferences.getInstance(); // Initialize prefs

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

  void filterProductsByCategory(String categoryName) {
    isLoading.value = true;
    if (categoryName == "All") {
      products.value = allProducts.toList(); // Show all
    } else {
      products.value = allProducts
          .where((product) => product.category.name == categoryName)
          .toList();
    }
    isLoading.value = false;
  }

  void setSelectedCategory(String category, int index) {
    selectedCategory.value = category;
    selectedCategoryIndex.value = index;
    filterProductsByCategory(category);
  }
}