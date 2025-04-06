import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbars {
  static void showSuccessSnackbar(String message, {String title = "Success"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 8,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCirc,
      reverseAnimationCurve: Curves.easeInCirc,
    );
  }

  static void showErrorSnackbar(String message, {String title = "Error"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 8,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3), // Adjust duration as needed
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCirc,
      reverseAnimationCurve: Curves.easeInCirc,
    );
  }

  static void showWarningSnackbar(String message, {String title = "Warning"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 8,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3), // Adjust duration as needed
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCirc,
      reverseAnimationCurve: Curves.easeInCirc,
    );
  }

// Add more types like info or warning if needed
}