import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/utils/constant/api_endpoints.dart';

import '../models/product_model.dart';
import '../models/user_model.dart';


class ApiService {
  static String baseUrl = ApiEndpoints.baseUrl;  // Replace with your actual base URL

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<ProductResponse?> getAllProducts() async {
    final token = await getToken();
    if (token == null) {
      // Handle the case where the token is not available (e.g., user not logged in)
      return null;
    }

    final url = Uri.parse('$baseUrl/allproducts');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        return ProductResponse.fromJson(decodedJson);
      } else {
        // Handle error based on status code
        print('Error: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Exception during API call: $e');
      return null;
    }
  }


  static Future<dynamic> placeOrder(Map<String, dynamic> requestBody) async {
    final token = await getToken();
    if (token == null) {
      // Handle no token
      return null;
    }

    final url = Uri.parse('$baseUrl/orders');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('API Response Status Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful response
        return jsonDecode(response.body); // Or your expected response
      } else {
        // Handle error
        print('Error: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      return null;
    }
  }

  static Future<ProfileModel?> getProfile() async {
    final token = await getToken();

    if (token == null) {
      // Handle the case where the token is not available (e.g., user not logged in)
      print('No token found');
      return null;
    }

    final url = Uri.parse('$baseUrl/users/getProfile');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        return ProfileModel.fromJson(decodedJson);
      } else {
        // Handle error based on status code
        print('Error: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Exception during API call: $e');
      return null;
    }
  }

  static Future<dynamic> resetPassword(Map<String, dynamic> requestBody) async {
    final url = Uri.parse('$baseUrl/reset-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception during API call: $e');
      return null;
    }
  }
}