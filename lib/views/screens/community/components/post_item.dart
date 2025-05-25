import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // Required for kDebugMode
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:women_health/controller/community_controller.dart';
import 'package:women_health/utils/constant/app_constant.dart';
import 'package:women_health/views/screens/community/comment_screen.dart';
import 'package:women_health/views/screens/community/edit_screen.dart';

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
    // Ensure that the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        currentUserId = prefs.getString('userId');
      });
    }
  }

  final CommunityController communityController =
      Get.find<CommunityController>();

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago'; // Shorter format
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago'; // Shorter format
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago'; // Shorter format
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago'; // Shorter format
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h), // Add some margin between items
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // Slight shadow adjustment
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
                // Consider using CachedNetworkImage for profile picture if available
                child: Text(
                  widget.post.userId?.name?.isNotEmpty == true
                      ? widget.post.userId!.name!.substring(0, 1).toUpperCase()
                      : 'U', // Fallback for empty or null name
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                // Use Expanded to prevent overflow if name is too long
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.userId?.name ?? 'Unknown User',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.post.createdAt != null)
                      Text(
                        _getTimeAgo(widget.post.createdAt!),
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                  ],
                ),
              ),
              // SizedBox(width: 5.w), // Removed as Spacer will handle spacing
              // Conditionally Show/Hide "Follow" Text
              if (currentUserId != null &&
                  widget.post.userId?.id != null &&
                  currentUserId != widget.post.userId!.id)
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w), // Add some padding
                  child: Obx(() {
                    // Use Obx for reactive updates from RxSet
                    final isFollowing = communityController.followingUserIds
                        .contains(widget.post.userId!.id!);
                    return InkWell(
                      onTap: () async {
                        // Prevent multiple taps while processing
                        if (communityController.isLoading.isFalse) {
                          await communityController
                              .toggleFollow(widget.post.userId!.id!);
                        }
                      },
                      child: Text(
                        isFollowing ? 'Following' : 'Follow',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isFollowing
                              ? Colors.green
                              : Theme.of(context)
                                  .primaryColor, // Use theme color
                        ),
                      ),
                    );
                  }),
                ),
              // const Spacer(), // Spacer might not be needed if actions are at the end
              if (currentUserId != null &&
                  widget.post.userId?.id != null &&
                  currentUserId == widget.post.userId!.id)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        iconSize: 20.sp, // Adjust icon size
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () {
                          // Pass the controller to avoid Get.find in EditPostScreen if not already organized
                          Get.to(() => EditPostScreen(post: widget.post));
                        },
                        icon: Icon(
                          Icons
                              .edit_outlined, // Use outlined icons for consistency
                          color: Colors.grey.shade600,
                        )),
                    SizedBox(width: 5.w),
                    IconButton(
                        iconSize: 20.sp,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () async {
                          // Show a confirmation dialog before deleting
                          Get.defaultDialog(
                              title: "Confirm Delete",
                              middleText:
                                  "Are you sure you want to delete this post?",
                              textConfirm: "Delete",
                              textCancel: "Cancel",
                              confirmTextColor: Colors.white,
                              onConfirm: () async {
                                Get.back(); // Close dialog
                                await communityController
                                    .postDelete(widget.post.id!);
                              });
                        },
                        icon: Icon(
                          Icons.delete_outline, // Use outlined icons
                          color: Colors.grey.shade600,
                        )),
                  ],
                )
            ],
          ),
          SizedBox(height: 10.h),

          // Post Title
          if (widget.post.title != null && widget.post.title!.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Text(
                widget.post.title!,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight:
                      FontWeight.w600, // Slightly less bold than full bold
                ),
              ),
            ),

          // SizedBox(height: 5.h), // Combined with title padding

          // Post Content
          if (widget.post.description != null &&
              widget.post.description!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: ConstrainedBox(
                    constraints: isExpanded
                        ? const BoxConstraints() // No max height when expanded
                        : BoxConstraints(
                            maxHeight: 40.0.h), // Responsive max height
                    child: Text(
                      widget.post.description!,
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                          height: 1.4), // Added line height
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                // Only show "More read" if the text is actually longer
                // This is a heuristic; a more accurate way involves LayoutBuilder
                if ((widget.post.description?.length ?? 0) >
                    80) // Heuristic: approx 2 lines
                  InkWell(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        isExpanded ? 'Show less' : 'Show more',
                        style: TextStyle(
                          fontSize: 13.sp, // Slightly smaller
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

          SizedBox(height: 10.h),

          // Image Thumbnail
          if (widget.post.image != null && widget.post.image!.isNotEmpty)
            ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: InkWell(
                  onTap: () {
                    // --- FIX IS HERE ---
                    if (widget.post.image != null &&
                        widget.post.image!.isNotEmpty) {
                      final imageProvider =
                          CachedNetworkImageProvider(widget.post.image!);
                      showImageViewer(
                        context,
                        imageProvider,
                        swipeDismissible: true,
                        doubleTapZoomable: true,
                        onViewerDismissed: () {
                          if (kDebugMode) {
                            print(
                                "Image viewer dismissed for post: ${widget.post.id}");
                          }
                        },
                      );
                    } else {
                      if (kDebugMode) {
                        print(
                            "No image URL to show in viewer for post: ${widget.post.id}");
                      }
                      // Optionally, show a snackbar if you want to inform the user
                      // Get.snackbar("Image Error", "This post does not have a viewable image.");
                    }
                  },
                  child: Container(
                    // Added Container for better height management and potential background
                    height: 200.h,
                    width: double.infinity, // Take full width
                    color: Colors
                        .grey.shade200, // Background color while loading/error
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          widget.post.image!, // Already checked for null/empty
                      placeholder: (context, url) {
                        return Center(
                            child: CupertinoActivityIndicator(radius: 15.r));
                      },
                      errorWidget: (context, url, error) {
                        return Center(
                            child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey.shade400,
                          size: 40.sp,
                        ));
                      },
                    ),
                  ),
                )),
          if (widget.post.image != null && widget.post.image!.isNotEmpty)
            SizedBox(height: 10.h),

          // Action Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 4.h), // Add a little space above actions
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Using Obx for like button as it depends on currentUserId which is async
                  // and widget.post.likes which can change.
                  Obx(() {
                    // Ensure currentUserId is loaded before building like button logic
                    if (currentUserId == null &&
                        communityController.isLoading.isTrue) {
                      // Show a placeholder or a disabled button while currentUserId is loading
                      return _buildAction(
                        Icons.thumb_up_alt_outlined,
                        'Support(${widget.post.totalLikes ?? 0})',
                        Colors.grey, // Disabled color
                        onTap: null, // No action
                      );
                    }
                    final isLikedByCurrentUser = widget.post.likes
                            ?.any((like) => like.id == currentUserId) ??
                        false;

                    return _buildAction(
                        isLikedByCurrentUser
                            ? Icons
                                .thumb_up_sharp // Or Icons.thumb_up for filled
                            : Icons.thumb_up_alt_outlined,
                        'Support(${widget.post.totalLikes ?? 0})', // Display totalLikes from post model
                        isLikedByCurrentUser
                            ? Theme.of(context).primaryColor
                            : Colors.black54, onTap: () {
                      if (currentUserId != null) {
                        // Only allow like if user is identified
                        communityController.toggleLike(widget.post);
                      } else {
                        Get.snackbar(
                            "Login Required", "Please login to support posts.");
                      }
                    });
                  }),
                  _buildAction(
                    Icons.mode_comment_outlined, // Outlined version
                    'Comment(${widget.post.totalComments ?? 0})', // Display totalComments from post model
                    Colors.black54,
                    onTap: () => Get.to(() => CommentScreen(
                        postId: widget.post.id!,
                        comments: widget.post.comments ?? [])),
                  ),
                  _buildAction(
                    Icons.share_outlined,
                    'Share',
                    Colors.black54,
                    onTap: _launchShare,
                  ),
                  Obx(() {
                    // Use Obx for reactive updates from RxSet
                    final isSaved = communityController.savedPostIds
                        .contains(widget.post.id);
                    return _buildAction(
                        isSaved
                            ? Icons.bookmark_sharp
                            : Icons.bookmark_outline, // Sharp for saved
                        isSaved ? 'Saved' : 'Save', // Dynamic label
                        isSaved
                            ? Theme.of(context).primaryColor
                            : Colors.black54, onTap: () {
                      communityController.toggleSavePost(widget.post.id!);
                      // setState is not needed here as Obx will react to savedPostIds change
                    });
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String label, Color? iconColor,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r), // for ripple effect
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 6.h, horizontal: 4.w), // Add some padding
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20.sp, color: iconColor ?? Colors.black54),
            SizedBox(width: 5.w),
            Text(label,
                style: TextStyle(
                    fontSize: 12.sp,
                    color: iconColor ?? Colors.black54,
                    fontWeight: FontWeight.w500 // Medium weight
                    )),
          ],
        ),
      ),
    );
  }

  Future<void> _launchShare() async {
    // You can customize the share text further, e.g., include post title or link
    final String shareText =
        "Check out this post on Women Health App: ${widget.post.title ?? ''}\n\n${AppConstant.shareAppLink}";
    final Uri shareUri = Uri.parse(
        'https://wa.me/?text=${Uri.encodeComponent(shareText)}'); // Example for WhatsApp

    // More generic share:
    // final String subject = "Check out this post: ${widget.post.title ?? ''}";
    // final String text = "Found this interesting post on Women Health App: ${widget.post.title ?? ''}. \n\nView it here: ${AppConstant.shareAppLink}"; // You might need a deep link to the specific post
    // final Uri mailUri = Uri(scheme: 'mailto', queryParameters: {'subject': subject, 'body': text});

    // For a generic share dialog, consider using the `share_plus` package.
    // For now, using url_launcher for a simple link.
    if (!await launchUrl(Uri.parse(AppConstant.shareAppLink))) {
      // This will open the app link directly
      // If you want to use a specific app like WhatsApp:
      // if (!await launchUrl(shareUri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not open share link.");
      // throw Exception('Could not launch ${AppConstant.shareAppLink}');
    }
  }
}
