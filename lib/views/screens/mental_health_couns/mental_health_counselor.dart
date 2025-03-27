import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/mental_health_controller.dart';
import 'package:women_health/core/helper/user_info_helper.dart';
import 'package:women_health/utils/constant/app_constant.dart';
import 'package:women_health/views/screens/mental_health_couns/meet_counsiler.dart';
import 'package:women_health/views/screens/mental_health_couns/post_details.dart';
import 'package:women_health/core/models/blog_model.dart'; // Import your blog model

class MentalHealthScreen extends StatelessWidget {
  MentalHealthScreen({Key? key}) : super(key: key); // Correct constructor
  final MentalHealthController controller = Get.put(MentalHealthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(context.tr('mental_health'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Get.to(MeetCounselorScreen()),
                  icon: Icon(Icons.people),
                  label: Text(context.tr('meet_counselor')),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    elevation: 0,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async{
                    await UserHelper.openEmail(AppConstant.email);
                  },
                  icon: Icon(Icons.mail),
                  label: Text(context.tr('mail_us')),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    elevation: 0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(context.tr('select_category'),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Obx(
              () => SingleChildScrollView(
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
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final filteredPosts = controller.getFilteredPosts();
                  return ListView.builder(
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = filteredPosts[index];
                      return _blogPostCard(
                        post: post,
                        onTap: () => Get.to(BlogPostDetailsScreen(post: post)),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blogPostCard(
      {required VoidCallback onTap, required BlogPostModel post}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
              child: Image.network(
                post.imageUrl != null && post.imageUrl!.isNotEmpty
                    ? post.imageUrl!
                    : 'https://via.placeholder.com/400x200', // Use a placeholder if the URL is invalid or empty
                width: double.infinity,
                height: 150.h,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // Handle image loading errors here
                  return Container(
                    width: double.infinity,
                    height: 150.h,
                    color: Colors.grey[300], // Show a grey background
                    child: Center(
                      child: Icon(Icons.error_outline,
                          color: Colors.grey[700]), // Show an error icon
                    ),
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
                    post.title ?? "No Title",
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  // Removed redundant description Text widget
                  SizedBox(height: 10.h),
                  Divider(),
                  SizedBox(height: 8.h),
                  Text(
                    (post.description != null && post.description!.length > 100)
                        ? post.description!.substring(0, 100) + '...'
                        : post.description ?? "",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
