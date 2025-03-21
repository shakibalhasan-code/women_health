// counselor_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/core/models/counselor_model.dart'; // Import the Counselor model

class CounselorDetailsScreen extends StatelessWidget {
  final Counselor counselor;

  const CounselorDetailsScreen({Key? key, required this.counselor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: const Icon(Icons.person, color: Colors.red),
        ),
        title: Text(
          'Counselor',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.close, color: Colors.black)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundImage:
                      NetworkImage(counselor.image), // Use Counselor's image
                  onBackgroundImageError: (exception, stackTrace) {
                    print(
                        'Error loading image for ${counselor.name}: $exception');
                  },
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      counselor.name, // Use Counselor's name
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      counselor.education, // Use Counselor's education
                      style: TextStyle(
                          fontSize: 14.sp, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                counselor.bio, // Use Counselor's bio
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
            ),
            SizedBox(height: 20.h),
            _buildDetailRow(Icons.location_on, 'Location',
                counselor.location ?? 'N/A'), // Use location
            _buildDetailRow(Icons.business_center, 'Experience',
                '${counselor.experience} Year +'), // Use experience
            _buildDetailRow(Icons.language, 'Email', counselor.email), //email
            _buildDetailRow(Icons.calendar_today, 'Availability',
                counselor.availability.join(', ')), //availability
            _buildDetailRow(Icons.access_time, 'Phone', counselor.phone),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Implement email functionality here
                  },
                  style: OutlinedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r)),
                  ),
                  child: Text(
                    'Email',
                    style: TextStyle(fontSize: 16.sp, color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement call functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                  ),
                  child: Text(
                    'Call now',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 20.sp),
          SizedBox(width: 10.w),
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, color: Colors.black),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ],
      ),
    );
  }
}
