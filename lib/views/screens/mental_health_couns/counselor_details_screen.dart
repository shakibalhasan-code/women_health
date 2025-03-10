import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';

class CounselorDetailsScreen extends StatelessWidget {
  const CounselorDetailsScreen({super.key});

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
            child: const Icon(Icons.close, color: Colors.black),
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
                      NetworkImage('https://example.com/counselor.jpg'),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Rahat Karim',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Relationship & Marriage Therapy',
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
                '"Dr. Ayesha Rahman is a certified clinical psychologist with over 8 years of experience in anxiety and stress management. She specializes in cognitive behavioral therapy (CBT) and mindfulness techniques to help individuals overcome emotional challenges. Her approach focuses on personalized care, ensuring clients feel heard, supported, and empowered. Dr. Ayesha has successfully guided hundreds of patients toward a healthier, more balanced life."',
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
            ),
            SizedBox(height: 20.h),
            _buildDetailRow(Icons.location_on, 'Location', 'Dhaka'),
            _buildDetailRow(Icons.business_center, 'Experience', '6 Year +'),
            _buildDetailRow(
                Icons.language, 'Language spoken', 'Bangla / English'),
            _buildDetailRow(
                Icons.calendar_today, 'Availability', 'Monday to Friday'),
            _buildDetailRow(Icons.access_time, 'Time', '10 AM - 5 PM'),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {},
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
                  onPressed: () {},
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
