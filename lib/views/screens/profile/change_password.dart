import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/profile_controller.dart';
import '../../../core/services/api_services.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final ProfileController profileController = Get.find<ProfileController>();
  final TextEditingController _currentPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: profileController.changePasswordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your email",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              _buildTextEmail("Email"),
              SizedBox(height: 16.h),
              Text(
                "Enter your new password",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              _buildPasswordField(_newPasswordController, "New Password",
                      (value) {
                    if (value == null || value.isEmpty) {
                      return "New Password is required";
                    }
                    return null;
                  }),
              SizedBox(height: 16.h),
              _buildPasswordField(
                  _confirmPasswordController, "Confirm New Password", (value) {
                if (value == null || value.isEmpty) {
                  return "New Password is required";
                }
                if (value != _newPasswordController.text) {
                  return "Confirm password do not match";
                }
                return null;
              }),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _changePassword(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: const Text(
                    "Update Password",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hintText,
      String? Function(String?)? validator) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.r),
        ),
        contentPadding:
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        suffixIcon: const Icon(Icons.lock, color: Colors.grey),
      ),
    );
  }

  Widget _buildTextEmail(String hintText) {
    return TextFormField(
      controller: profileController.emailController,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.r),
        ),
        contentPadding:
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    if (profileController.changePasswordFormKey.currentState!.validate()) {
      final email = profileController.emailController.text;
      final newPassword = _newPasswordController.text;
      final confirmPassword = _confirmPasswordController.text;

      final Map<String, dynamic> requestBody = {
        "email": email,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword
      };

      try {
        final response = await ApiService.resetPassword(requestBody);

        if (response != null) {
          Get.snackbar('Success', 'Password reset successfully!');
          Get.back();
        } else {
          Get.snackbar('Error', 'Failed to reset password. Please try again.');
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred: $e');
      }
    }
  }
}