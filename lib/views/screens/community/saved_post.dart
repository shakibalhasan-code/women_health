import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:women_health/controller/community_controller.dart';

class SavedPostsScreen extends StatelessWidget {
  SavedPostsScreen({Key? key}) : super(key: key);

  final CommunityController communityController =
      Get.find<CommunityController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.bookmark, color: Colors.red, size: 22.sp),
                    SizedBox(width: 8.w),
                    Text(
                      "Saved Post",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 22.sp, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Recent Title & Delete All
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                // TextButton(
                //   onPressed: () {
                //     // Implement delete all logic
                //   },
                //   child:
                //       Text("Delete all", style: TextStyle(color: Colors.red)),
                // ),
              ],
            ),

            SizedBox(height: 10.h),

            // List of Saved Posts
            SizedBox(
              height: 400.h, // Adjust height as needed
              child: Obx(() {
                // Use Obx to listen for changes in savedPostIds
                final savedPostIds = communityController.savedPostIds;
                if (savedPostIds.isEmpty) {
                  return const Center(child: Text("No saved posts."));
                }

                // Filter the posts to get only saved ones.  Crucially, we're
                // filtering based on the currently loaded `posts`.
                final savedPosts = communityController.posts
                    .where((post) => savedPostIds.contains(post.id))
                    .toList();

                return ListView.builder(
                  itemCount: savedPosts.length,
                  itemBuilder: (context, index) {
                    final post = savedPosts[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        children: [
                          // Thumbnail
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                post.image ?? 'https://via.placeholder.com/50',
                                width: 50.w,
                                height: 50.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error_outline);
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),

                          // Post Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.title ?? "No Title",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  _getTimeAgo(post.createdAt!),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Remove Button
                          TextButton(
                            onPressed: () {
                              communityController.toggleSavePost(post.id!);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            child: const Text("Remove",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
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
}
