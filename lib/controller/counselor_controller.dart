// counselor_controller.dart

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// Ensure this path is correct for your project structure
import 'package:women_health/utils/constant/api_endpoints.dart';
import 'dart:convert';

// Ensure this path is correct for your project structure
import '../core/models/counselor_model.dart'; // Import the corrected model

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
          // This line will now work correctly with the fixed Counselor.fromJson
          counselors.value =
              counselorList.map((json) => Counselor.fromJson(json)).toList();
          printInfo(info: '==========>>>>>>>> $counselorList');
          print({'counselors fetched count:': counselors.length});
          // If you want to see details of the first counselor (if any)
          // if (counselors.isNotEmpty) {
          //   print({'First counselor name:': counselors.first.name});
          // }
        } else {
          // Handle the case where the 'counselors' key is missing or the data structure is unexpected
          print('Unexpected JSON structure: $jsonData');
          // Potentially set an error message for the UI
        }
      } else {
        // Handle API error
        print('Failed to load counselors. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Potentially set an error message for the UI
      }
    } catch (e, stackTrace) {
      // Handle network, parsing, or other errors
      print('Error fetching counselors: $e');
      print('Stack trace: $stackTrace');
      // Potentially set an error message for the UI
    } finally {
      isLoading(false);
    }
  }
}
