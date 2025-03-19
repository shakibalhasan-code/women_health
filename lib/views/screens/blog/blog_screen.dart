import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/blog_controller.dart';
import 'package:women_health/views/screens/mental_health_couns/post_details.dart';

import '../../../core/models/blog_model.dart';

class BlogScreen extends StatelessWidget {
  BlogScreen({super.key});
  final BlogController controller = Get.put(BlogController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Health & Wellness Blog",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select a category",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.categories.map((category) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: controller.selectedCategory.value == category,
                          selectedColor: Colors.red,
                          onSelected: (isSelected) {
                            if (isSelected) {
                              controller.selectCategory(category);
                            }
                          },
                          labelStyle: TextStyle(
                            color: controller.selectedCategory.value == category
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 15.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.getFilteredPosts().length,
                    itemBuilder: (context, index) {
                      final post = controller.getFilteredPosts()[index];
                      return _blogPostCard(context, post);
                    },
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  Widget _blogPostCard(BuildContext context, BlogPostModel post) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogPostDetailsScreen(post: post,),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
              child: Image.network(
                post.imageUrl ?? 'https://via.placeholder.com/400x200', // Use imageUrl from the model
                width: double.infinity,
                height: 150.h,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  // Handle image loading errors
                  return Container(
                    height: 150.h,
                    color: Colors.grey.shade200,
                    child: Center(child: Icon(Icons.error_outline)),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title ?? "No Title", // Use title from the model
                    style:
                    TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    post.description ?? "No Description", // Use description from the model
                    style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
