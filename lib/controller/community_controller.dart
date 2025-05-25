import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/utils/constant/api_endpoints.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:women_health/utils/helper/widget_helper.dart';
import 'package:women_health/utils/widgets/custom_snackbar.dart';
import '../core/models/community_post_model.dart';

class CommunityController extends GetxController {
  RxList<String> categories = <String>["All"].obs;
  var selectedCategory = 'All'.obs;
  var isLikedPost = false.obs;
  var allComments = [].obs;
  // Add these:
  RxList<CommunityPostModel> posts = <CommunityPostModel>[].obs;
  RxBool isLoading = true.obs;
  SharedPreferences? prefs;
  RxBool isSearchLoading = false.obs;
  RxString searchQuery = "".obs; // Track Search Query.
  // Add these for the create post screen
  final titleController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  Rx<File?> selectedImage = Rx<File?>(null);

  // Search-related variables
  RxList<CommunityPostModel> searchResults = <CommunityPostModel>[].obs;
  var isUpdating = false.obs;

  // Saved posts
  RxSet<String> savedPostIds =
      <String>{}.obs; // Use a Set for efficient checking

  RxSet<String> followingUserIds = <String>{}.obs;

  // BannerAd? bannerAd;
  // bool _isLoaded = false;

  final editTitleController = TextEditingController();
  final editDescriptionController = TextEditingController();

// TODO: replace this test ad unit with your own ad unit.
  final adUnitId = 'ca-app-pub-3940256099942544/6300978111';

  @override
  void onInit() async {
    super.onInit();
    await initializeSharedPreferences(); // Wait until prefs is initialized
    // It's generally better to fetch categories before posts if posts depend on categories for display/filtering right away
    // or if posts API needs a category. In this case, order seems fine.
    await fetchCategories(); // Fetch categories first
    await fetchPosts(); // Then fetch posts
    await loadSavedPosts(); // Load saved post IDs from SharedPreferences
    await loadFollowingUsers();
    // await showBannerAds();
  }

// 🟢 1. Fetching all categories (from secured endpoint)
  Future<void> fetchCategories() async {
    try {
      final token = prefs?.getString('token');
      if (token == null) {
        print('No token found for categories');
        // Optionally, if no token, clear categories or revert to a default state
        // categories.value = ["All"];
        // if (selectedCategory.value != "All") selectedCategory.value = "All";
        return;
      }

      final response = await http.get(
        Uri.parse(ApiEndpoints.allCategory), // Make sure this is correct
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Ensure 'categories' key exists and is a list
        if (jsonData['categories'] != null && jsonData['categories'] is List) {
          final List<dynamic> categoryListJson = jsonData['categories'];
          final List<String> fetchedNames =
              categoryListJson.map((e) => e['name'].toString()).toList();

          // Create a new list starting with "All"
          final List<String> newCategoryList = ["All"];
          // Add all fetched category names
          newCategoryList.addAll(fetchedNames);

          // Use assignAll or .value to update the RxList. This replaces the entire content.
          categories.assignAll(newCategoryList);
          // Alternatively: categories.value = newCategoryList;

          // If the currently selected category is no longer in the list
          // (e.g., it was removed from the backend), reset to "All".
          if (!categories.contains(selectedCategory.value)) {
            selectedCategory.value = "All";
          }
        } else {
          print(
              'Failed to fetch categories: "categories" field missing, null, or not a list.');
          // Fallback: ensure "All" is still there and selected
          categories.value = ["All"];
          if (selectedCategory.value != "All") selectedCategory.value = "All";
        }
      } else {
        print('Failed to fetch categories: ${response.statusCode}');
        // Optionally, handle this error case, e.g., by not changing categories
        // or setting them to a default error state.
      }
    } catch (e) {
      print('Error fetching categories: $e');
      // Optionally, handle this error.
    }
  }

  Future<void> postEdit(String postId) async {
    try {
      isUpdating.value = true;

      final token = prefs?.getString('token');
      if (token == null) {
        print('No token found in shared preferences');
        Get.snackbar('Error', 'Please Login First',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Assuming your API for editing a post might change its category or other details
      // that would warrant refreshing all posts and potentially categories.
      // The actual PUT request for editing should include the new title/description.
      // The current implementation of postEdit seems to be missing the body with new data.
      // For example:
      // body: jsonEncode({
      //   'title': editTitleController.text,
      //   'description': editDescriptionController.text,
      //   // 'category': newCategoryValue, // if category can be changed
      // }),

      final response = await http.put(
        Uri.parse(
            '${ApiEndpoints.baseUrl}/users/Posts/$postId'), // Ensure this endpoint is correct for editing
        headers: {
          "Authorization": 'Bearer $token', // Corrected: Add 'Bearer ' prefix
          "Content-Type": "application/json",
        },
        // IMPORTANT: You need to send the updated data in the body
        body: jsonEncode({
          'title': editTitleController
              .text, // Assuming you populate these before calling
          'description': editDescriptionController.text,
          // Add other fields that can be edited
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar('Success', data['message'] ?? 'Post updated');
        editTitleController.clear();
        editDescriptionController.clear();
        await refresh(); // Refresh data, which includes categories
      } else {
        Get.snackbar('Failed', data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> postDelete(String postId) async {
    try {
      final token = prefs?.getString('token');
      if (token == null) {
        print('No token found in shared preferences');
        Get.snackbar('Error', 'Please Login First',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final response = await http.delete(
        Uri.parse('${ApiEndpoints.baseUrl}/users/Posts/$postId'),
        headers: {
          "Authorization": 'Bearer $token', // Corrected: Add 'Bearer ' prefix
          // "Content-Type": "application/json", // Not always needed for DELETE, but doesn't hurt
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar('Success', data['message'] ?? 'Post deleted');
        await refresh(); // Refresh data, which includes categories
      } else {
        Get.snackbar('Failed', data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> addComment(String postId, String commentText) async {
    try {
      final token = prefs?.getString('token');
      if (token == null) {
        print('No token found in shared preferences');
        Get.snackbar('Error', 'Please Login First',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final apiUrl = '${ApiEndpoints.baseUrl}/comment/$postId';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'commentText': commentText,
        }),
      );
      // allComments.add(commentText); // This updates a local list, but fetchPosts will get the authoritative list
      // refresh(); // Calling refresh() here might be too broad if you only want to update comments for a specific post

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Comment added successfully!');
        await fetchPosts(); // Re-fetch all posts to update comments count.
        // For better UX, you might want to update only the specific post's comment list/count locally first,
        // then rely on fetchPosts for full sync if needed.
        Get.back(); // Close the comment input screen/dialog
        Get.snackbar('Success', 'Comment Added Successfully',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        print(
            'Failed to add comment: ${response.statusCode} - ${response.body}');
        Get.snackbar('Error', 'Failed to add comment: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error adding comment: $e');
      Get.snackbar('Error', 'Error adding comment: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> toggleFollow(String userId) async {
    try {
      final token = prefs?.getString('token');
      if (token == null) {
        print('No token found in shared preferences');
        Get.snackbar('Error', 'Please Login First',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final apiUrl = '${ApiEndpoints.baseUrl}/users/follow/$userId';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Follow status toggled successfully!');

        // Update local state after successful API call
        final isFollowing = followingUserIds.contains(userId);
        if (isFollowing) {
          followingUserIds.remove(userId);
        } else {
          followingUserIds.add(userId);
        }
        await saveFollowingUsers(); // Persist the change
        // No need to call refresh() unless following status impacts the post list directly (e.g., filtering)

        Get.snackbar('Success', 'Follow status toggled',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        print(
            'Failed to toggle follow: ${response.statusCode} - ${response.body}');
        Get.snackbar('Error', 'Failed to toggle follow: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error toggling follow: $e');
      Get.snackbar('Error', 'Error toggling follow: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setSelectedCategory(String category) {
    if (categories.contains(category)) {
      // Ensure the category is valid
      selectedCategory.value = category;
    } else {
      print(
          "Warning: Attempted to select a non-existent category: $category. Defaulting to 'All'.");
      selectedCategory.value = "All";
    }
    // No need to call fetchPosts() here usually, filtering is local.
    // If API supports category-based fetching for `allPost`, then you might.
  }

  List<CommunityPostModel> getFilteredPosts() {
    if (selectedCategory.value == "All") {
      return posts;
    } else {
      return posts
          .where((post) => post.category == selectedCategory.value)
          .toList();
    }
  }

  void searchPosts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      searchResults.clear(); // Clear results if query is empty
      isSearchLoading.value = false;
      return;
    }
    isSearchLoading.value = true; // Set loading true before starting search
    // Debounce could be useful here if query is from live typing

    final lowercaseQuery = query.toLowerCase();
    searchResults.value = posts.where((post) {
      final title = post.title?.toLowerCase() ?? '';
      final description = post.description?.toLowerCase() ?? '';
      // Add other fields to search if needed, e.g., post.user?.name
      return title.contains(lowercaseQuery) ||
          description.contains(lowercaseQuery);
    }).toList();

    isSearchLoading.value = false;
  }

  Future<void> fetchPosts() async {
    try {
      isLoading(true);
      print('Fetching posts from API...');

      // Determine the endpoint: all posts or posts by category or search query
      // For simplicity, this example keeps fetching all posts.
      // If your API supports filtering by category or search server-side, adjust Uri.parse.
      final response = await http.get(
        Uri.parse(ApiEndpoints.allPost),
        // headers: prefs?.getString('token') != null ? {'Authorization': 'Bearer ${prefs?.getString('token')}'} : {}, // If posts are secured
      );

      print('Response received with status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData;
        try {
          jsonData = json.decode(response.body) as Map<String, dynamic>;
        } on FormatException catch (e, s) {
          print(
              "Error: Failed to decode JSON for posts. The response body is not valid JSON.");
          print("FormatException: $e");
          print(
              "Response body was: ${response.body.substring(0, response.body.length > 1000 ? 1000 : response.body.length)}..."); // Print partial body
          print("Stacktrace: $s");
          posts.clear(); // Clear posts to indicate an error state or no data
          return;
        } catch (e, s) {
          print("Error decoding or casting top-level JSON for posts: $e");
          print("Stacktrace: $s");
          posts.clear();
          return;
        }

        if (jsonData.containsKey('posts') && jsonData['posts'] is List) {
          final List<dynamic> postsListJson =
              jsonData['posts'] as List<dynamic>;
          List<CommunityPostModel> fetchedPosts = [];

          for (int i = 0; i < postsListJson.length; i++) {
            final dynamic postItemJson = postsListJson[i];
            if (postItemJson is Map<String, dynamic>) {
              try {
                fetchedPosts.add(CommunityPostModel.fromJson(postItemJson));
              } catch (e, s) {
                print('Error parsing post at index $i:');
                print('Problematic post JSON: $postItemJson');
                print('Parsing Error: $e');
                print('Stacktrace: $s');
              }
            } else {
              print(
                  'Error: Item at index $i in "posts" list is not a valid post object (Map). Found: $postItemJson');
            }
          }
          posts.assignAll(fetchedPosts);
          print('Successfully parsed ${fetchedPosts.length} posts.');
        } else {
          print(
              "Error: 'posts' key is missing or not a list in the response for posts.");
          print("jsonData was: $jsonData");
          posts.clear();
        }
      } else {
        print("API Error fetching posts: ${response.statusCode}");
        print("Response body: ${response.body}");
        posts.clear(); // Clear posts on API error
      }
    } catch (e, s) {
      print('Error fetching posts: $e');
      print('Stacktrace: $s');
      posts.clear(); // Clear posts on general error
    } finally {
      isLoading(false);
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
    } else {
      print('No image selected.');
      // Get.snackbar('Warning', 'No image selected', snackPosition: SnackPosition.BOTTOM); // Optional: less intrusive not to show snackbar here
    }
  }

  Future<void> writePost() async {
    // This method seems to be a duplicate of createPost, choose one
    try {
      isLoading(true); // You might want a specific isLoading for post creation
      final token = prefs?.getString('token');
      final categoryName = selectedCategory
          .value; // Ensure this is a valid category from your list

      if (titleController.value.text.isEmpty) {
        Get.snackbar('Error', 'Title cannot be empty',
            snackPosition: SnackPosition.BOTTOM);
        isLoading(false);
        return;
      }
      if (descriptionController.value.text.isEmpty) {
        Get.snackbar('Error', 'Description cannot be empty',
            snackPosition: SnackPosition.BOTTOM);
        isLoading(false);
        return;
      }
      if (categoryName == "All" || !categories.contains(categoryName)) {
        // Assuming "All" is not a valid category to post to, or require specific selection
        Get.snackbar('Error', 'Please select a valid category',
            snackPosition: SnackPosition.BOTTOM);
        isLoading(false);
        return;
      }

      if (token == null) {
        print('No token found in shared preferences');
        Get.snackbar('Error', 'No token found. Please login again.',
            snackPosition: SnackPosition.BOTTOM);
        isLoading(false);
        return;
      }

      if (selectedImage.value == null) {
        print('No image selected');
        Get.snackbar('Warning', 'Please select an image',
            snackPosition: SnackPosition.BOTTOM);
        isLoading(false);
        return;
      }

      var request =
          http.MultipartRequest('POST', Uri.parse(ApiEndpoints.createPost));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['title'] = titleController.value.text;
      request.fields['description'] = descriptionController.value.text;
      request.fields['category'] =
          categoryName; // Use the selected category name

      var imageFile = File(selectedImage.value!.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // API field name for the image
          imageFile.path,
          contentType:
              MediaType('image', 'jpeg'), // Adjust if necessary (png, etc.)
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // 201 Created is more typical for POST
        print('Post created successfully!');
        titleController.value.clear();
        descriptionController.value.clear();
        selectedImage.value = null;
        Get.back(); // Go back from create post screen
        await fetchPosts(); // Refresh posts list

        Get.snackbar('Success', 'Post created successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        print(
            'Failed to create post: ${response.statusCode} - ${response.body}');
        Get.snackbar('Error', 'Failed to create post: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error creating post: $e');
      Get.snackbar('Error', 'Error creating post: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(
          false); // Reset general loading, or specific post creation loading
    }
  }

  Future<void> toggleLike(CommunityPostModel post) async {
    final originalLikes =
        post.likes?.length ?? 0; // Or however you track like count

    // Optimistic UI update (optional, but good for UX)
    // This requires your CommunityPostModel to be mutable or for you to replace it in the list.
    // For simplicity, we'll rely on fetchPosts to update.

    try {
      // isLoading(true); // Can use a per-post loading state if many posts are visible
      final token = prefs?.getString('token');
      if (token == null) {
        Get.snackbar('Error', 'Please Login First',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      final response = await http.put(
        Uri.parse(
            '${ApiEndpoints.baseUrl}/like/${post.id}'), // Ensure endpoint is correct
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Successfully liked/unliked on server
        // Instead of fetching all posts, ideally, the API response for like/unlike
        // would return the updated post object or at least the new like count and status.
        // Then you can update just that specific post in your `posts` list.
        // For now, fetchPosts() is a simpler way to ensure data consistency.
        await fetchPosts();
        // The snackbar might be better if it reflects the action (liked/unliked)
        // String message = (json.decode(response.body)['liked'] ?? false) ? 'Post Liked' : 'Post Unliked';
        Get.snackbar('Success', 'Like Status Updated',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        print('API call failed with status code: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to process like action: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
        // Revert optimistic update if you did one
      }
    } catch (e) {
      print('Full error toggling like: $e');
      Get.snackbar('Error', 'Error while processing like action: $e',
          snackPosition: SnackPosition.BOTTOM);
      // Revert optimistic update
    } finally {
      // isLoading(false);
    }
  }

  // This `createPost` method is redundant if `writePost` is used.
  // If you keep it, ensure it's distinct or remove one.
  // Future<void> createPost({
  //   required String title,
  //   required String description,
  //   required File image,
  // }) async {
  //   // ... implementation ... (similar to writePost)
  // }

  Future<void> toggleSavePost(String postId) async {
    final bool isCurrentlySaved = savedPostIds.contains(postId);

    // Optimistic UI update
    if (isCurrentlySaved) {
      savedPostIds.remove(postId);
    } else {
      savedPostIds.add(postId);
    }
    // No need to call update() for RxSet, it's reactive.

    // Persist to SharedPreferences
    await saveSavedPosts();

    // Optional: sync with backend (your commented-out code)
    // If you have a backend endpoint for saved posts, call it here.
    // Handle success/failure and revert optimistic UI if backend call fails.
    // Example:
    // try {
    //   final token = prefs?.getString('token');
    //   if (token == null) { /* handle */ return; }
    //   final response = await http.post(Uri.parse('${ApiEndpoints.baseUrl}/post/saved/$postId'), headers: {'Authorization': 'Bearer $token'});
    //   if (response.statusCode == 200) {
    //     Get.snackbar('Success', 'Post save status updated on server.', snackPosition: SnackPosition.BOTTOM);
    //   } else {
    //     // Revert optimistic UI
    //     if (isCurrentlySaved) savedPostIds.add(postId); else savedPostIds.remove(postId);
    //     await saveSavedPosts();
    //     Get.snackbar('Error', 'Failed to sync save status with server.', snackPosition: SnackPosition.BOTTOM);
    //   }
    // } catch (e) {
    //   // Revert optimistic UI
    //   if (isCurrentlySaved) savedPostIds.add(postId); else savedPostIds.remove(postId);
    //   await saveSavedPosts();
    //   Get.snackbar('Error', 'Error syncing save status: $e', snackPosition: SnackPosition.BOTTOM);
    // }
  }

  Future<void> loadSavedPosts() async {
    final saved = prefs?.getStringList('savedPosts') ?? [];
    savedPostIds
        .clear(); // Clear before loading to prevent duplicates if called multiple times
    savedPostIds.addAll(saved);
  }

  Future<void> saveSavedPosts() async {
    await prefs?.setStringList('savedPosts', savedPostIds.toList());
  }

  Future<void> loadFollowingUsers() async {
    final following = prefs?.getStringList('followingUsers') ?? [];
    followingUserIds.clear(); // Clear before loading
    followingUserIds.addAll(following);
  }

  Future<void> saveFollowingUsers() async {
    await prefs?.setStringList('followingUsers', followingUserIds.toList());
  }

  @override
  Future<void> refresh() async {
    // Consider what truly needs to be refreshed.
    // Fetching categories on every pull-to-refresh might be excessive if they don't change often.
    isLoading(true); // Indicate loading during refresh
    await fetchPosts();
    await fetchCategories(); // This will now correctly rebuild the list
    // Optionally: await loadSavedPosts(); await loadFollowingUsers(); if they can change server-side without direct user action.
    isLoading(false);
  }

  // Ad-related methods (showBannerAds, showInterstitialAds) would go here
  // ...
}
