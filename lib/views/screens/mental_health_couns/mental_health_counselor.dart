import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/mental_health_controller.dart';
import 'package:women_health/views/screens/mental_health_couns/meet_counsiler.dart';
import 'package:women_health/views/screens/mental_health_couns/post_details.dart';

class MentalHealthScreen extends StatelessWidget {
  MentalHealthScreen({super.key});
  final MentalHealthController controller = Get.put(MentalHealthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Icon(Icons.volunteer_activism, color: Colors.red),
            // SizedBox(width: 8.w),
            Text("Mental Health Counseling",
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
                  label: Text("Meet a Counselor"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    elevation: 0,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.mail),
                  label: Text("Mail us"),
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
                  return _blogPostCard(
                      onTap: () => Get.to(BlogPostDetailsScreen()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blogPostCard({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
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
                    "How to Manage Anxiety in Daily Life",
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Meditation is a powerful tool for stress relief and emotional balance. Learn how to incorporate meditation into your daily routine to achieve mental clarity and relaxation.",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                  ),
                  SizedBox(height: 10.h),
                  Divider(),
                  SizedBox(height: 8.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("🧘 Find a quiet space for meditation"),
                      Text("🌬️ Focus on deep breathing exercises"),
                      Text("🌀 Let go of distractions and negative thoughts"),
                      Text("⏳ Be consistent for best long-term results"),
                    ],
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
