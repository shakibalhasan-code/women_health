import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:women_health/controller/community_controller.dart';
import 'package:women_health/views/screens/community/all_matched_screen.dart';

class MatchFollowingScreen extends StatelessWidget {
  MatchFollowingScreen({super.key});

  final communityController = Get.put(CommunityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: const Icon(Icons.people, color: Colors.red),
        ),
        title: Text(
          'Match & Following',
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
            Obx(() => _buildSection(
                'Partner Matched', communityController.matchedUsers)),
            SizedBox(height: 20.h),
            Obx(() => _buildSection(
                'Followed people', communityController.followedUsers)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, String>> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.w),
          color: Colors.red.shade50,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 15.w,
          runSpacing: 15.h,
          children: users.map((user) => _buildUserItem(user)).toList(),
        ),
        SizedBox(height: 10.h),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => Get.to(AllMatchedScreen()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            ),
            child: Text(
              'All',
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserItem(Map<String, String> user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundImage:
              user['image'] != null ? NetworkImage(user['image']!) : null,
          backgroundColor: user['image'] == null ? Colors.grey.shade300 : null,
          child: user['image'] == null
              ? Icon(Icons.person, color: Colors.black, size: 24.sp)
              : null,
        ),
        SizedBox(height: 5.h),
        Text(
          user['name']!,
          style: TextStyle(fontSize: 12.sp, color: Colors.black),
        ),
      ],
    );
  }
}
