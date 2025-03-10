import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/counselor_controller.dart';

class MeetCounselorScreen extends StatelessWidget {
  MeetCounselorScreen({super.key});

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
              child: Obx(
                () => ListView.separated(
                  itemCount: counselorController.counselors.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final counselor = counselorController.counselors[index];
                    return _buildCounselorItem(counselor);
                  },
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                  side: BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r)),
                ),
                child: Text(
                  'More',
                  style: TextStyle(fontSize: 16.sp, color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCounselorItem(Map<String, String> counselor) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.r,
        backgroundImage: NetworkImage(counselor['image']!),
      ),
      title: Text(
        counselor['name']!,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Specialization: ${counselor['specialization']}',
        style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
      ),
      trailing: OutlinedButton(
        onPressed: () {},
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
