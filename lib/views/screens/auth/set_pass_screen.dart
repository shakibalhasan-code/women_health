import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/utils/constant/app_theme.dart'; // Adjust import path
import 'package:women_health/views/glob_widgets/my_button.dart';

import '../../../controller/auth_controller.dart'; // Adjust import path
// Assuming AuthController is in a separate file


class SetPassScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final String email = Get.arguments as String; // Email passed from VerifyEmailOtpScreen
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  SetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Set New Password',
              style: AppTheme.titleLarge.copyWith(color: AppTheme.primaryColor),
            ),
            SizedBox(height: 5.h),
            Text(
              'Enter your new password below',
              style: AppTheme.titleSmall.copyWith(color: Colors.black),
            ),
            SizedBox(height: 15.h),
            TextFormField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'New Password',
              ),
            ),
            SizedBox(height: 15.h),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Confirm Password',
              ),
            ),
            SizedBox(height: 20.h),
            Obx(() => ElevatedButton(
              onPressed: authController.isLoading.value
                  ? null
                  : () {
                final newPassword = newPasswordController.text;
                final confirmPassword = confirmPasswordController.text;

                if (newPassword.isEmpty || confirmPassword.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please fill in both fields',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else if (newPassword != confirmPassword) {
                  Get.snackbar(
                    'Error',
                    'Passwords do not match',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  authController.setNewPassword(
                    email,
                    newPassword,
                    confirmPassword,
                  );
                }
              },
              child: authController.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save Password'),
            )),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Get.offAllNamed('/login'), // Adjust route
                  child: Text(
                    'Back to Login',
                    style: AppTheme.titleSmall
                        .copyWith(color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}