import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:women_health/core/models/community_post_model.dart';
import 'package:women_health/controller/community_controller.dart';
import 'package:women_health/views/screens/community/comment_screen.dart';

class CommunityPostDetailsScreen extends StatelessWidget {
  final CommunityPostModel post;

  const CommunityPostDetailsScreen({Key? key, required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CommunityController communityController = Get.find<CommunityController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
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
                      _getTimeAgo(post.createdAt!),
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                Obx(() {
                  final isSaved =
                  communityController.savedPostIds.contains(post.id);
                  return InkWell(
                    onTap: () {
                      communityController.toggleSavePost(post.id!);
                    },
                    child: _buildAction(
                      isSaved ? Icons.bookmark : Icons.bookmark_outline,
                      'Save',
                      isSaved ? Colors.blue : Colors.black,
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: 20.h),

            // Post Title
            Text(
              post.title ?? 'No Title',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),

            // Category
            Text(
              'Category: ${post.category ?? 'No Category'}',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16.h),

            // Post Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                post.image ?? 'https://via.placeholder.com/600x300',
                width: double.infinity,
                height: 300.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 300.h,
                    color: Colors.grey.shade200,
                    child: const Center(child: Icon(Icons.error_outline)),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),

            // Post Description
            Text(
              post.description ?? 'No Description',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.h),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  final isLiked =
                      post.likes.any((like) => like.id == 'userId') ?? false;
                  return InkWell(
                    onTap: () async{
                      await communityController.toggleLike(post);
                    },
                    child: _buildAction(
                      isLiked
                          ? Icons.thumb_up_sharp
                          : Icons.thumb_up_alt_outlined,
                      isLiked
                          ? 'Supported(${post.totalLikes})'
                          : 'Support(${post.totalLikes})',
                      isLiked ? Colors.blue : Colors.black,
                    ),
                  );
                }),
                InkWell(
                  onTap: () => Get.to(CommentScreen(
                    postId: post.id!,
                    comments: post.comments ?? [],
                  )),
                  child: _buildAction(Icons.comment_outlined,
                      'Comment(${post.totalComments})', Colors.black),
                ),
                InkWell(
                  onTap: () {},
                  child:
                  _buildAction(Icons.share_outlined, 'Share', Colors.black),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy')
          .format(dateTime); // Format date like "Dec 25, 2023"
    }
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