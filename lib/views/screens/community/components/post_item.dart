import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:heroicons/heroicons.dart';
import 'package:women_health/controller/community_controller.dart';
import 'package:women_health/views/screens/community/comment_screen.dart';

class CommunityPostItem extends StatelessWidget {
  CommunityPostItem({super.key});
  final communityController = Get.put(CommunityController());
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Section
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: Colors.purple.shade100,
                child: Text('A', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Asmaul Husna',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '2 hours ago',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Follow',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Post Title
          Text(
            'Missed My Period! Should I Be Worried? 🤔"',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 5.h),

          // Post Content
          Text(
            'Hey everyone! My period is 5 days late, and my cycle is usually regular (28 days)....... ',
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
          Text(
            'More read',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10.h),

          // Video Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  'https://images.immediate.co.uk/production/volatile/sites/10/2024/08/2048x1365-onion-flower-SEO-GettyImages-1373032064-4f135dd.jpg?resize=1200%2C630',
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                return InkWell(
                    onTap: () {
                      communityController.isLikedPost.value =
                          !communityController.isLikedPost.value;
                    },
                    child: _buildAction(
                        communityController.isLikedPost.value
                            ? Icons.thumb_up_sharp
                            : Icons.thumb_up_alt_outlined,
                        'Support',
                        communityController.isLikedPost.value
                            ? Colors.blue
                            : Colors.black));
              }),
              InkWell(
                  onTap: () => Get.to(CommentScreen()),
                  child: _buildAction(
                      Icons.comment_outlined, 'Comment', Colors.black)),
              InkWell(
                  onTap: () {},
                  child: _buildAction(
                      Icons.share_outlined, 'Share', Colors.black)),
              _buildAction(Icons.bookmark_outline, 'Save', Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String label, Color? selectedColor) {
    return Row(
      children: [
        Icon(icon, size: 20, color: selectedColor),
        SizedBox(width: 5.w),
        Text(label, style: TextStyle(fontSize: 12.sp, color: selectedColor)),
      ],
    );
  }
}
