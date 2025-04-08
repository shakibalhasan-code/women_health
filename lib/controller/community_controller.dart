import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/utils/constant/api_endpoints.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart'; // For MediaType
import 'package:women_health/utils/helper/widget_helper.dart';
import 'package:women_health/utils/widgets/custom_snackbar.dart';
import '../core/models/community_post_model.dart';
import 'package:mime_type/mime_type.dart';

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
    await fetchPosts(); // Now call fetchPosts
    await fetchCategories();
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

      final response = await http.put(
        Uri.parse('${ApiEndpoints.baseUrl}/Posts/$postId'),
        headers: {
          "Authorization": token,
          "Content-Type": "application/json", // optional, but good to include
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar('Success', data['message'] ?? 'Post updated');
        refresh();
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
        Uri.parse('${ApiEndpoints.baseUrl}/Posts/$postId'),
        headers: {
          "Authorization": token,
          "Content-Type": "application/json",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar('Success', data['message'] ?? 'Post deleted');
        refresh();
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
      allComments.add(commentText);
      refresh();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Comment added successfully!');
        // Optionally: Refresh the posts or comments
        await fetchPosts(); // Re-fetch all posts to update comments count, this may not be efficient for large data
        Get.back();
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
        await saveFollowingUsers();

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
    selectedCategory.value = category;
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

  // 🟢 NEW: Local Search Function
  void searchPosts(String query) {
    searchQuery.value = query; // save search Query.
    isSearchLoading.value = true;
    searchResults.clear();

    if (query.isEmpty) {
      searchResults.value = [];
      isSearchLoading.value = false;
      return;
    }

    final lowercaseQuery = query.toLowerCase();

    searchResults.value = posts.where((post) {
      final title = post.title?.toLowerCase() ?? '';
      final description = post.description?.toLowerCase() ?? '';
      return title.contains(lowercaseQuery) ||
          description.contains(lowercaseQuery);
    }).toList();
    isSearchLoading.value = false;
  }

  Future<void> fetchPosts() async {
    try {
      isLoading(true);
      print('Fetching posts from API...');

      final response = await http.get(
        Uri.parse(ApiEndpoints.allPost), // Change URL as needed
      );

      print('Response received with status code: ${response.statusCode}');
      print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        print('Decoded JSON response: $jsonResponse');

        // fix here:
        posts.value = jsonResponse.map((item) {
          return CommunityPostModel.fromJson(item);
        }).toList();

        print('Successfully fetched and parsed posts');
      } else {
        print('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      isLoading(false);
    }
  }

  // Function to pick an image
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
    } else {
      print('No image selected.');
      Get.snackbar(
        'Warning',
        'No image selected',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Function to write a post
  Future<void> writePost() async {
    try {
      isLoading(true);
      final token = prefs?.getString('token');
      final categoryName = selectedCategory.value;

      if (token == null) {
        print('No token found in shared preferences');
        isLoading(false);
        Get.snackbar(
          'Error',
          'No token found. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (selectedImage.value == null) {
        print('No image selected');
        isLoading(false);
        Get.snackbar(
          'Warning',
          'Please select an image',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Create multipart request
      var request =
          http.MultipartRequest('POST', Uri.parse(ApiEndpoints.createPost));
      request.headers['Authorization'] = 'Bearer $token'; // Add token to header
      request.fields['title'] = titleController.value.text;
      request.fields['description'] = descriptionController.value.text;
      request.fields['category'] = categoryName;

      // Add the image file
      var imageFile = File(selectedImage.value!.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // This should match your API field name
          imageFile.path,
          contentType: MediaType('image',
              'jpeg'), // Adjust the content type based on your image type
        ),
      );

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Post created successfully!');
        Get.back();
        // Clear the fields
        titleController.value.clear();
        descriptionController.value.clear();
        selectedImage.value = null;
        fetchPosts(); // Refresh posts

        Get.snackbar(
          'Success',
          'Post created successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        print(
            'Failed to create post: ${response.statusCode} - ${response.body}');
        Get.snackbar(
          'Error',
          'Failed to create post: ${response.statusCode} - ${response.body}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error creating post: $e');
      Get.snackbar(
        'Error',
        'Error creating post: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> toggleLike(CommunityPostModel post) async {
    try {
      isLoading(true);
      final token = prefs?.getString('token');
      print(token);
      if (token == null) {
        print('No token found in shared preferences');
        isLoading(false);
        Get.snackbar('Error', 'Please Login First',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      final response = await http.put(
        Uri.parse('${ApiEndpoints.baseUrl}/like/${post.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // After a successful like/unlike, re-fetch the posts list to get updated like information.
        await fetchPosts();
        Get.snackbar('Success', 'Like Status Updated',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        print('API call failed with status code: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to process like action: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Full error: $e');
      Get.snackbar('Error', 'Error while processing like action: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> createPost({
    required String title,
    required String description,
    required File image,
  }) async {
    final String apiUrl = ApiEndpoints.createPost; // Replace with your API URL
    final token = prefs?.getString('token');
    print(token);
    if (token == null) {
      print('No token found in shared preferences');
      isLoading(false);
      Get.snackbar('Error', 'Please Login First',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    var request = http.MultipartRequest("POST", Uri.parse(apiUrl))
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['title'] = title
      ..fields['category'] = selectedCategory.value
      ..fields['description'] = description
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        print("Post created successfully!");
        Get.back();
        fetchPosts();
      } else {
        print("Failed to create post: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // 🟢 Save Post Logic
  Future<void> toggleSavePost(String postId) async {
    final bool isCurrentlySaved = savedPostIds.contains(postId);

    // Immediately update local state
    if (isCurrentlySaved) {
      savedPostIds.remove(postId);
    } else {
      savedPostIds.add(postId);
    }
    await saveSavedPosts(); // Save the updated list to SharedPreferences

    // // Make the API call in the background
    // try {
    //   final token = prefs?.getString('token');
    //   if (token == null) {
    //     print('No token found in shared preferences');
    //     Get.snackbar('Error', 'Please Login First',
    //         snackPosition: SnackPosition.BOTTOM);
    //     return;
    //   }
    //
    //   final String apiUrl = '${ApiEndpoints.baseUrl}/post/saved/$postId';
    //   final response = await http.post(
    //     Uri.parse(apiUrl),
    //     headers: {'Authorization': 'Bearer $token'},
    //   );
    //
    //   if (response.statusCode == 200) {
    //     Get.snackbar('Success', 'Post saved status updated',
    //         snackPosition: SnackPosition.BOTTOM);
    //   } else {
    //     print('API call failed with status code: ${response.statusCode}');
    //     // Get.snackbar('Error', 'Failed to save post on server: ${response.body}',
    //     //     snackPosition: SnackPosition.BOTTOM);
    //   }
    // } catch (e) {
    //   print('Error saving post: $e');
    //   Get.snackbar('Error', 'Error while saving post on server: $e',
    //       snackPosition: SnackPosition.BOTTOM);
    // }
  }

  // 🟢 Load Saved Posts from SharedPreferences
  Future<void> loadSavedPosts() async {
    final saved = prefs?.getStringList('savedPosts') ?? [];
    savedPostIds.addAll(saved);
  }

  // 🟢 Save Saved Posts to SharedPreferences
  Future<void> saveSavedPosts() async {
    await prefs?.setStringList('savedPosts', savedPostIds.toList());
  }

  // Load Following Users from SharedPreferences
  Future<void> loadFollowingUsers() async {
    final following = prefs?.getStringList('followingUsers') ?? [];
    followingUserIds.addAll(following);
  }

  // Save Following Users to SharedPreferences
  Future<void> saveFollowingUsers() async {
    await prefs?.setStringList('followingUsers', followingUserIds.toList());
  }

  @override
  Future<void> refresh() async {
    await fetchPosts();
    await fetchCategories();
  }

  // Future<void> showBannerAds() async {
  //   // Implement your banner ad logic here
  //   // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
  //   final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
  //       MediaQuery.sizeOf(Get.context!).width.truncate());

  //   bannerAd = BannerAd(
  //     adUnitId: adUnitId,
  //     request: const AdRequest(),
  //     size:
  //         size ?? AdSize.banner, // Fallback to a default AdSize if size is null
  //     listener: BannerAdListener(
  //       // Called when an ad is successfully received.
  //       onAdLoaded: (ad) {
  //         debugPrint('$ad loaded.');
  //         _isLoaded = true;
  //       },
  //       // Called when an ad request failed.
  //       onAdFailedToLoad: (ad, err) {
  //         debugPrint('BannerAd failed to load: $err');
  //         // Dispose the ad here to free resources.
  //         ad.dispose();
  //       },
  //     ),
  //   )..load();
  // }

  Future<void> showInterstitialAds() async {
    // Implement your interstitial ad logic here
  }
}
