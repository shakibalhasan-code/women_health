import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/views/screens/marketplace/payment_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "X-Corolla",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    "https://media.cdn-jaguarlandrover.com/api/v2/images/55880/w/680.jpg",
                    width: double.infinity,
                    height: 250.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "X-Corolla",
                style:
                    AppTheme.titleLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "Toyota",
                style: AppTheme.titleSmall.copyWith(color: Colors.grey),
              ),
              SizedBox(height: 8.h),
              Text(
                "\$25,000",
                style: AppTheme.titleMedium.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Divider(),
              SizedBox(height: 8.h),
              Text(
                "Description",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                "The X-Corolla is a stylish and powerful sedan known for its exceptional performance, fuel efficiency, and advanced safety features. Designed with a sleek exterior and a comfortable, spacious interior, this vehicle is perfect for city driving and long journeys alike. The Toyota X-Corolla offers top-tier technology, including a smart infotainment system, adaptive cruise control, and premium leather seating.",
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
              SizedBox(height: 20.h),
              Divider(),
              SizedBox(height: 12.h),
              Center(
                child: ElevatedButton(
                  onPressed: () => Get.to(PaymentScreen()),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 32.w),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    "Proceed to Buy",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
