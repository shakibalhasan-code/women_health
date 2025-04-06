import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/community_controller.dart';
import 'package:women_health/core/models/community_post_model.dart';
import 'package:women_health/views/screens/marketplace/components/category_item.dart'; // Reuse CategoryItem

class EditPostScreen extends StatelessWidget {
  final CommunityPostModel post; // Receive the post to edit

  EditPostScreen({super.key, required this.post});

  // Find the controller - assumes it's already initialized elsewhere
  final CommunityController communityController = Get.find<CommunityController>();

  @override
  Widget build(BuildContext context) {
    // Note: setupEditScreen should have been called *before* navigating here.
    // We read the values from the controller's edit properties.

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1, // Add a slight elevation for separation
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Post',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true, // Center title for edit screen
      ),
      body: SingleChildScrollView(
        child: Obx(() => Padding( // Use Obx to react to controller changes
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select a category',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  // spacing: 8.w, // Use Padding instead of spacing for Row
                  children: communityController.categories.map((category) {
                    final bool isSelected = communityController.selectedCategory.value == category;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w), // Spacing between items
                      child: GestureDetector(
                          onTap: () {
                            communityController.selectedCategory.value = category;
                          },
                          child: CategoryItem( // Reuse your CategoryItem
                              categoryName: category,
                              isSelected: isSelected,
                              onTap: () {
                                communityController.selectedCategory.value = category;
                              }
                          )
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Title',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5.h),
              TextField(
                controller: communityController.editTitleController, // Use EDIT controller
                decoration: InputDecoration(
                  hintText: 'Enter post title',
                  border: OutlineInputBorder( // Add border
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5.h),
              TextField(
                controller: communityController.editDescriptionController, // Use EDIT controller
                decoration: InputDecoration(
                  hintText: 'Describe your post...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                ),
                maxLines: 5, // Allow more lines for description
                minLines: 3,
              ),
              SizedBox(height: 15.h),

              // --- Image Handling ---
              Text(
                'Image (Optional)',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),

              // Show current or newly selected image
              Obx(() {
                final newImagePath = communityController.selectedImage.value?.path;
                final originalImageUrl = post.image;

                Widget imagePreview = SizedBox.shrink(); // Default to empty

                if (newImagePath != null) {
                  // Show newly selected image
                  imagePreview = Image.file(
                    File(newImagePath),
                    height: 150.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                } else if (originalImageUrl != null && originalImageUrl.isNotEmpty) {
                  // Show original image
                  imagePreview = Image.network(
                    originalImageUrl,
                    height: 150.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150.h,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: Center(child: Text('Could not load image')),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (newImagePath != null || (originalImageUrl != null && originalImageUrl.isNotEmpty))
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: imagePreview,
                      ),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: () {
                        communityController.selectedImage(); // Use specific picker for edit
                      },
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt_outlined, color: Colors.black54),
                          SizedBox(width: 8.w),
                          Text(
                            newImagePath != null ? 'Change Photo' : (originalImageUrl != null && originalImageUrl.isNotEmpty ? 'Change Photo' : 'Add Photo'),
                            style: TextStyle(fontSize: 14.sp, color: Colors.blue),
                          ),
                          if(newImagePath != null)
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Text("New photo selected", style: TextStyle(color: Colors.green, fontSize: 12.sp)),
                            )
                        ],
                      ),
                    ),
                    // Option to remove image (if applicable)
                    // if (newImagePath != null || (originalImageUrl != null && originalImageUrl.isNotEmpty))
                    //   TextButton(onPressed: () { /* Logic to clear image */}, child: Text("Remove Image", style: TextStyle(color: Colors.red)))
                  ],
                );

              }),
              // --- End Image Handling ---

              SizedBox(height: 40.h), // More space before button
              Center(
                child: Obx(() => ElevatedButton( // Obx for loading state
                  onPressed: communityController.isUpdating.value ? null : () {
                    // Call update method from controller
                    communityController.postEdit(post.id!); // Pass the post ID
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.red.shade200, // Disabled color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 50.w, vertical: 15.h),
                  ),
                  child: communityController.isUpdating.value
                      ? SizedBox( // Constrained loading indicator
                    height: 20.sp, // Match text size
                    width: 20.sp,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                      : Text(
                    'Update Post',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                )),
              ),
              SizedBox(height: 20.h), // Space at the bottom
            ],
          ),
        )),
      ),
    );
  }
}