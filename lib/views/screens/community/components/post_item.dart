import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/community_controller.dart';
import 'package:women_health/views/screens/community/comment_screen.dart';

import '../../../../core/models/community_post_model.dart';

class CommunityPostItem extends StatelessWidget {
  final CommunityPostModel post;

  CommunityPostItem({Key? key, required this.post}) : super(key: key);

  final communityController = Get.find<CommunityController>();

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
                child: Text(
                  post.userId?.name?.substring(0, 1).toUpperCase() ?? 'A',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.userId?.name ?? 'Unknown User',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${DateTime.now().difference(post.createdAt!).inHours} hours ago', // Adjust as needed
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
            post.title ?? 'No Title',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 5.h),

          // Post Content
          Text(
            post.description ?? 'No Description',
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

          // Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  post.image ?? 'https://via.placeholder.com/400x200', // Placeholder if no image
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200.h,
                      color: Colors.grey.shade200,
                      child: const Center(child: Icon(Icons.error_outline)),
                    );
                  },
                ),
                // You can add a play icon here if it's a video
              ],
            ),
          ),
          SizedBox(height: 10.h),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final isLiked = post.likes?.any((like) => like.id == 'userId') ?? false;
                return InkWell(
                  onTap: () {
                    communityController.toggleLike(post);
                  },
                  child: _buildAction(
                    isLiked ? Icons.thumb_up_sharp : Icons.thumb_up_alt_outlined,
                    isLiked ? 'Supported(${post.totalLikes})' : 'Support(${post.totalLikes})', // Update text dynamically and show total likes
                    isLiked ? Colors.blue : Colors.black,
                  ),
                );
              }),
              InkWell(
                onTap: () => Get.to(CommentScreen(postId: post.id!,comments: post.comments ?? [],)),
                child: _buildAction(Icons.comment_outlined, 'Comment(${post.totalComments})', Colors.black), // Show total comments
              ),
              InkWell(
                onTap: () {},
                child: _buildAction(Icons.share_outlined, 'Share', Colors.black),
              ),
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