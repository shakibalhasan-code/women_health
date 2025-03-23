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
                'Thank You!',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Your order has been placed successfully. We will contact you very soon, keep using our app',
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
                  child: const Text('Back to Marketplace'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}