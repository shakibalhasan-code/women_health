import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/views/screens/auth/set_pass_screen.dart';
import 'package:women_health/views/screens/auth/verify_email_otp_screen.dart';
import 'package:women_health/utils/constant/api_endpoints.dart';

import '../views/screens/home/home_screen.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final String userIdKey = 'user_id'; // Key for storing user ID in SharedPreferences

  // Register user
  Future<void> registerUser(String name, String email, String password) async {
    try {
      isLoading(true);
      debugPrint('Registering user with email: $email');

      final response = await http.post(
        Uri.parse(ApiEndpoints.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      debugPrint('Register API Response: ${response.statusCode}');
      debugPrint('Register API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Save email to SharedPreferences
        await _saveEmailToPrefs(email);

        Get.snackbar(
          'Success',
          data['message'] ?? 'User registered successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        // You might want to navigate to login screen here
        // Get.to(() => LoginScreen());
      } else {
        Get.snackbar(
          'Error',
          'Registration failed: ${jsonDecode(response.body)['message'] ?? 'Unknown error'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Register error: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
      debugPrint('Register process finished');
    }
  }

// Login user
  Future<void> loginUser(String email, String password) async {
    try {
      isLoading(true);
      debugPrint('Logging in user with email: $email');

      final response = await http.post(
        Uri.parse(ApiEndpoints.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      debugPrint('Login API Response: ${response.statusCode}');
      debugPrint('Login API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save the token
        final token = data['token'];  // Get token from response
        await _saveTokenToPrefs(token); // Save the token

        // Save the user ID
        final userId = data['user']['_id']; // Assuming your API returns the user ID in this format
        await _saveUserIdToPrefs(userId); // Save the user ID to SharedPreferences

        // Save email to SharedPreferences
        await _saveEmailToPrefs(email);


        Get.snackbar(
          'Success',
          'Logged in successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        // Navigate to home screen
        Get.offAll(() => HomeScreen());
      } else {
        Get.snackbar(
          'Error',
          'Login failed: ${jsonDecode(response.body)['message'] ?? 'Invalid credentials'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
      debugPrint('Login process finished');
    }
  }

  // Helper function to save the token to SharedPreferences
  Future<void> _saveTokenToPrefs(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);  // Use 'token' as the key
    debugPrint('Token saved to SharedPreferences: $token');
  }

  // Helper function to save the email to SharedPreferences
  Future<void> _saveEmailToPrefs(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    debugPrint('Email saved to SharedPreferences: $email');
  }
  // Helper function to save the userId to SharedPreferences
  Future<void> _saveUserIdToPrefs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    debugPrint('userId saved to SharedPreferences: $userId');
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      isLoading(true);
      debugPrint('Sending forgot password request for email: $email');

      final response = await http.post(
        Uri.parse(ApiEndpoints.forget),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      debugPrint('Forgot Password API Response: ${response.statusCode}');
      debugPrint('Forgot Password API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        Get.snackbar(
          'Success',
          data['message'] ?? 'OTP sent to your email',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        // Navigate to OTP verification screen
        Get.to(() => VerifyEmailOtpScreen(), arguments: email);
      } else {
        Get.snackbar(
          'Error',
          'Failed: ${jsonDecode(response.body)['message'] ?? 'Unknown error'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Forgot Password error: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
      debugPrint('Forgot Password process finished');
    }
  }

  // Verify OTP
  Future<void> verifyOtp(String email, String otp) async {
    try {
      isLoading(true);
      debugPrint('Verifying OTP for email: $email');

      final response = await http.post(
        Uri.parse(ApiEndpoints.verify),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      );

      debugPrint('Verify OTP API Response: ${response.statusCode}');
      debugPrint('Verify OTP API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Get.snackbar(
          'Success',
          'OTP verified successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        // Navigate to reset password screen
        Get.to(() => SetPassScreen(), arguments: email);
      } else {
        Get.snackbar(
          'Error',
          'OTP verification failed: ${jsonDecode(response.body)['message'] ?? 'Invalid OTP'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Verify OTP error: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
      debugPrint('Verify OTP process finished');
    }
  }

  Future<void> setNewPassword(String email, String newPassword, String confirmPassword) async {
    try {
      isLoading(true);
      debugPrint('Setting new password for email: $email');

      final response = await http.post(
        Uri.parse(ApiEndpoints.resetPass),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      debugPrint('Set New Password API Response: ${response.statusCode}');
      debugPrint('Set New Password API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        Get.snackbar(
          'Success',
          data['message'] ?? 'Password updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        // Navigate to login screen
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Error',
          'Failed: ${jsonDecode(response.body)['message'] ?? 'Unknown error'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Set New Password error: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
      debugPrint('Set New Password process finished');
    }
  }



  // Get email from SharedPreferences
  Future<String?> getEmailFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  // Get token from SharedPreferences
  Future<String?> getTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }


  // Get User ID from SharedPreferences
  Future<String?> getUserIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(userIdKey);
    debugPrint('Retrieved User ID: $userId');
    return userId;
  }

  //Remove user ID from SharedPreferences (logout)
  Future<void> removeUserIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userIdKey);
    debugPrint('User ID removed from SharedPreferences (logout)');
  }
}