import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:women_health/controller/community_controller.dart';
import 'package:women_health/views/screens/marketplace/components/category_item.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({super.key});

  final communityController = Get.find<CommunityController>(); // Find, not Put

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: const Icon(Icons.edit, color: Colors.red),
        ),
        title: Text(
          'Create a post',
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
      body: SingleChildScrollView(
        child: Obx(() => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                      spacing: 8.w,
                      children: communityController.categories.map((category) {
                        return GestureDetector(
                            onTap: () {
                              communityController.setSelectedCategory(category);
                            },
                            child: CategoryItem(
                                categoryName: category,
                                isSelected:
                                    communityController.selectedCategory.value ==
                                        category,
                                onTap: () {
                                  communityController.selectedCategory.value =
                                      category;
                                }));
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
                    controller: communityController
                        .titleController.value, // Use GetX controller
                    decoration: InputDecoration(
                      hintText: 'Write here',
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
                    controller: communityController
                        .descriptionController.value, // Use GetX controller
                    decoration: InputDecoration(
                      hintText: 'Write here',
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 15.h),
                  GestureDetector(
                    onTap: () {
                      communityController.pickImage();
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.camera_alt_outlined,
                            color: Colors.black),
                        SizedBox(width: 5.w),
                        Text(
                          'Add photo',
                          style: TextStyle(fontSize: 14.sp, color: Colors.black),
                        ),
                        SizedBox(width: 10.w),
                        if (communityController.selectedImage.value != null)
                          Text(
                            'Image Selected',
                            style:
                                TextStyle(fontSize: 12.sp, color: Colors.green),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (communityController.selectedImage.value != null)
                    Image.file(
                      File(communityController.selectedImage.value!.path),
                      height: 100.h,
                      width: 100.w,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 30.h),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        communityController.writePost();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 50.w, vertical: 15.h),
                      ),
                      child: communityController.isLoading.value
                          ? CircularProgressIndicator(
                              color: Colors.white) // Show loader
                          : Text(
                              'Post now',
                              style:
                                  TextStyle(fontSize: 16.sp, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
