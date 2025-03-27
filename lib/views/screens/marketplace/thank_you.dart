import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/views/screens/tab/tab_screen.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100.sp,
              ),
              SizedBox(height: 24.h),
              Text(
                'thank_you'.tr, // Translated "Thank You!"
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'order_placed_message'.tr, // Translated "Your order has been placed successfully..."
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: () {
                  Get.offAll(TabScreen());
                },
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 10.w
                  ),
                  child: Text('back_to_marketplace'.tr), // Translated "Back to Marketplace"
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}