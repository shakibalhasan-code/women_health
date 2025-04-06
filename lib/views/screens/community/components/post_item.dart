import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:women_health/controller/community_controller.dart';
import 'package:women_health/utils/constant/app_constant.dart';
import 'package:women_health/views/screens/community/comment_screen.dart';

import '../../../../core/models/community_post_model.dart';

class CommunityPostItem extends StatefulWidget {
  final CommunityPostModel post;

  CommunityPostItem({Key? key, required this.post}) : super(key: key);

  @override
  State<CommunityPostItem> createState() => _CommunityPostItemState();
}

class _CommunityPostItemState extends State<CommunityPostItem> {
  String? currentUserId;
  bool isExpanded = false; // Track expansion state

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('userId');
    });
  }

  final CommunityController communityController =
  Get.find<CommunityController>();

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
          .format(dateTime);
    }
  }

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
                  widget.post.userId?.name?.substring(0, 1).toUpperCase() ??
                      'A',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.userId?.name ?? 'Unknown User',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getTimeAgo(widget.post.createdAt!),
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(width: 5.w),
              // Conditionally Show/Hide "Follow" Text
              if (currentUserId != widget.post.userId?.id)
                GetBuilder<CommunityController>(
                  builder: (controller) {
                    final isFollowing = controller.followingUserIds.contains(widget.post.userId!.id!);
                    return InkWell(
                      onTap: () async {
                        await controller.toggleFollow(widget.post.userId!.id!);
                      },
                      child: Text(
                        isFollowing ? 'Following' : 'Follow',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isFollowing ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              const Spacer(),
              if (currentUserId != widget.post.userId?.id)
              Row(
                children: [
                  IconButton(onPressed: ()async{
                    await  communityController.postEdit(widget.post.id!);
                  }, icon: Icon(Icons.edit,color: Colors.grey,)),
                  SizedBox(width: 5.w),
                  IconButton(onPressed: ()async{
                   await  communityController.postDelete(widget.post.id!);
                  }, icon: Icon(Icons.delete,color: Colors.grey,)),
                ],
              )
            ],
          ),
          SizedBox(height: 10.h),

          // Post Title
          Text(
            widget.post.title ?? 'No Title',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 5.h),

          // Post Content
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: ConstrainedBox(
              constraints: isExpanded
                  ? const BoxConstraints()
                  : const BoxConstraints(maxHeight: 40.0),
              child: Text(
                widget.post.description ?? 'No Description',
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'Less' : 'More read',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
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
                  widget.post.image ??
                      'https://via.placeholder.com/400x200',
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
              GetBuilder<CommunityController>(builder: (controller) {
                final isLiked =
                    widget.post.likes?.any((like) => like.id == currentUserId) ??
                        false;
                return InkWell(
                  onTap: () {
                    communityController.toggleLike(widget.post);
                  },
                  child: _buildAction(
                    isLiked
                        ? Icons.thumb_up_sharp
                        : Icons.thumb_up_alt_outlined,
                    isLiked
                        ? 'Supported(${widget.post.totalLikes})'
                        : 'Support(${widget.post.totalLikes})',
                    isLiked ? Colors.blue : Colors.black,
                  ),
                );
              }),
              InkWell(
                onTap: () => Get.to(CommentScreen(
                    postId: widget.post.id!, comments: widget.post.comments ?? []
                )),
                child: _buildAction(
                    Icons.comment_outlined,
                    'Comment(${widget.post.totalComments})',
                    Colors.black),
              ),
              InkWell(
                onTap: () async{
                  await _launchShare();
                },
                child:
                _buildAction(Icons.share_outlined, 'Share', Colors.black),
              ),
              GetBuilder<CommunityController>(builder: (controller) {
                final isSaved =
                communityController.savedPostIds.contains(widget.post.id);
                return InkWell(
                  onTap: () {
                    communityController.toggleSavePost(widget.post.id!);
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

  Future<void> _launchShare() async {
    if (!await launchUrl(Uri.parse(AppConstant.shareAppLink))) {
      throw Exception('Could not launch');
    }
  }
}