import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/blog_controller.dart';
import 'package:women_health/views/screens/mental_health_couns/post_details.dart';

class BlogScreen extends StatelessWidget {
  BlogScreen({super.key});
  final BlogController controller = Get.put(BlogController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Icon(Icons.article, color: Colors.red),
            // SizedBox(width: 8.w),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select a category",
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
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _blogPostCard(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blogPostCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogPostDetailsScreen(),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
              child: Image.network(
                'https://media.istockphoto.com/id/1513072392/photo/hands-holding-paper-head-human-brain-with-flowers-self-care-and-mental-health-concept.jpg?s=612x612&w=0&k=20&c=CCzxREX01-dEqN3P_1M1ZrsZeenCxTmDWbp-goLwjMc=',
                width: double.infinity,
                height: 150.h,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "10 Ways to Improve Your Mental Health",
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Explore effective strategies to enhance mental well-being, reduce stress, and cultivate a positive mindset.",
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
