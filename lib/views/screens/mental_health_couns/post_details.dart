import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlogPostDetailsScreen extends StatelessWidget {
  const BlogPostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog Details"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.record_voice_over, color: Colors.black)),
          SizedBox(
            width: 10.w,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  'https://media.istockphoto.com/id/1513072392/photo/hands-holding-paper-head-human-brain-with-flowers-self-care-and-mental-health-concept.jpg?s=612x612&w=0&k=20&c=CCzxREX01-dEqN3P_1M1ZrsZeenCxTmDWbp-goLwjMc=',
                  width: double.infinity,
                  height: 250.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "How to Manage Anxiety in Daily Life",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Meditation is a powerful tool for stress relief and emotional balance. Learn how to incorporate meditation into your daily routine to achieve mental clarity and relaxation.\n\n"
                "🧘 Find a quiet space for meditation\n"
                "🌬️ Focus on deep breathing exercises\n"
                "🌀 Let go of distractions and negative thoughts\n"
                "⏳ Be consistent for best long-term results\n\n"
                "Taking time to center yourself and practice mindfulness can significantly improve your mental well-being. Whether it's through deep breathing, visualization, or relaxation techniques, small daily efforts can have a profound impact on managing anxiety and stress levels.",
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
