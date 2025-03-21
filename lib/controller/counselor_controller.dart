// counselor_controller.dart

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:women_health/utils/constant/api_endpoints.dart';
import 'dart:convert';

import '../core/models/counselor_model.dart'; // Import the model

class CounselorController extends GetxController {
  RxList<Counselor> counselors = <Counselor>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCounselors();
  }

  Future<void> fetchCounselors() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          ApiEndpoints.getAllcounselors)); // Adjust endpoint if needed

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is Map<String, dynamic> &&
            jsonData.containsKey('counselors')) {
          final List<dynamic> counselorList = jsonData['counselors'];
          counselors.value =
              counselorList.map((json) => Counselor.fromJson(json)).toList();
          print({'counselors>>>>>>>>>': counselors});
        } else {
          // Handle the case where the 'counselors' key is missing or the data structure is unexpected
          print('Unexpected JSON structure: $jsonData');
        }
      } else {
        // Handle API error
        print('Failed to load counselors. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing error
      print('Error fetching counselors: $e');
    } finally {
      isLoading(false);
    }
  }
}
