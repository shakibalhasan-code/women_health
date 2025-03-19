import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/utils/constant/api_endpoints.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart'; // For MediaType
import '../core/models/community_post_model.dart';

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
  var isLikedPost = false.obs;

  // Add these:
  RxList<CommunityPostModel> posts = <CommunityPostModel>[].obs;
  RxBool isLoading = true.obs;
  SharedPreferences? prefs;

  // Add these for the create post screen
  final titleController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() async{
    super.onInit();
    await initializeSharedPreferences(); // Wait until prefs is initialized
    fetchPosts(); // Now call fetchPosts
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
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
      var request = http.MultipartRequest('POST', Uri.parse(ApiEndpoints.createPost));
      request.headers['Authorization'] = 'Bearer $token'; // Add token to header
      request.fields['title'] = titleController.value.text;
      request.fields['description'] = descriptionController.value.text;
      request.fields['categoryName'] = categoryName;

      // Add the image file
      var imageFile = File(selectedImage.value!.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // This should match your API field name
          imageFile.path,
          contentType: MediaType(
              'image', 'jpeg'), // Adjust the content type based on your image type
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
        print('Failed to create post: ${response.statusCode} - ${response.body}');
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
        // Optimistically update likes locally
        final isLiked = post.likes?.any((like) => like.id == 'userId') ?? false;

        if (isLiked) {
          post.likes?.removeWhere((like) => like.id == 'userId');
        } else {
          post.likes?.add(User(id: 'userId', name: 'userName', email: 'userEmail'));
        }
        //For instant like and dislike update after clicking action btn
        posts.refresh();
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


//Helper function to toggle the liked post
/*void toggleLike(CommunityPostModel post) {
    final index = posts.indexOf(post);
    if (index != -1) {
      final isLiked = post.likes?.any((like) => like.id == 'userId'); // Replace 'userId' with the actual user ID if available
      if (isLiked != null && isLiked) {
        // Unlike the post
        post.likes?.removeWhere((like) => like.id == 'userId'); // Replace 'userId' with the actual user ID if available
      } else {
        // Like the post
        post.likes?.add(User(id: 'userId', name: 'userName', email: 'userEmail')); // Replace with actual user data
      }
      posts.refresh(); // Trigger UI update
    }
  }*/
}