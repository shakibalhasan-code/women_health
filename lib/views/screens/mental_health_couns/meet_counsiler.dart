// meet_counselor_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/counselor_controller.dart';
import 'package:women_health/utils/constant/api_endpoints.dart';
import 'package:women_health/views/screens/mental_health_couns/counselor_details_screen.dart';
import 'package:women_health/core/models/counselor_model.dart'; // Import Counselor model

class MeetCounselorScreen extends StatelessWidget {
  MeetCounselorScreen({Key? key}) : super(key: key); // Use Key? key

  final counselorController = Get.put(CounselorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Health & Counselor',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Near You',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                if (counselorController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.separated(
                    itemCount: counselorController.counselors.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final counselor = counselorController.counselors[index];
                      return _buildCounselorItem(counselor);
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounselorItem(Counselor counselor) {
    String baseUrl = ApiEndpoints.baseUrl;
    String fullImageUrl = counselor.image.isNotEmpty
        ? '$baseUrl/${counselor.image}'
        : 'https://via.placeholder.com/150';

    // Use the Counselor model
    return ListTile(
      leading: CircleAvatar(
        radius: 25.r,
        backgroundImage: NetworkImage(fullImageUrl), // Access image directly
        onBackgroundImageError: (exception, stackTrace) {
          print('Error loading image for ${counselor.name}: $exception');
        },
      ),
      title: Text(
        counselor.name, // Access name directly
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Experience: ${counselor.experience} years', // Access experience
        style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
      ),
      trailing: OutlinedButton(
        onPressed: () => Get.to(CounselorDetailsScreen(counselor: counselor)),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          side: BorderSide(color: Colors.grey.shade400),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
        ),
        child: Text(
          'Details',
          style: TextStyle(fontSize: 14.sp, color: Colors.black),
        ),
      ),
    );
  }
}
