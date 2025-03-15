import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:women_health/utils/constant/app_theme.dart';

import '../../../controller/auth_controller.dart';

class VerifyEmailOtpScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final String email = Get.arguments as String; // Pass email from ForgetScreen
  final TextEditingController otpController = TextEditingController();

  VerifyEmailOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.primaryColor),
        ),
        backgroundColor: Colors.white, //Add BackgroundColor as white
        elevation: 0, //Remove shadow
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Verify your email',
              style: AppTheme.titleLarge.copyWith(color: AppTheme.primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h),
            Text(
              'We\'ve sent you an OTP code to your email address, please check and enter the OTP below',
              style: AppTheme.titleSmall.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: otpController,
              onChanged: (value) {},
              onCompleted: (value) {
                authController.verifyOtp(email, value);
              },
              pinTheme: AppTheme.pinTheme,
              backgroundColor: Colors.transparent,
              keyboardType: TextInputType.text, // Restrict input to numbers
            ),
            SizedBox(height: 15.h),
            Obx(
                  () => ElevatedButton(
                onPressed: authController.isLoading.value
                    ? null // Disable the button while loading
                    : () {
                  if (otpController.text.length == 6) {
                    authController.verifyOtp(email, otpController.text);
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please enter a valid 6-digit OTP',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                  textStyle: TextStyle(fontSize: 16.sp),
                ),
                child: authController.isLoading.value
                    ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
                    : Text(
                  'Verify Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => authController.forgotPassword(email),
                  child: Text(
                    'Didn\'t receive the code? Resend',
                    style: AppTheme.titleSmall.copyWith(color: AppTheme.primaryColor),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}