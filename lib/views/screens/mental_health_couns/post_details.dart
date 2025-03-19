import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/models/blog_model.dart';

class BlogPostDetailsScreen extends StatelessWidget {
  final BlogPostModel post; // Take a BlogPostModel as input

  const BlogPostDetailsScreen({Key? key, required this.post}) : super(key: key);

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
                  post.imageUrl ?? 'https://via.placeholder.com/400x200', // Use post.imageUrl
                  width: double.infinity,
                  height: 250.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Handle image loading errors
                    return Container(
                      height: 250.h,
                      color: Colors.grey.shade200,
                      child: Center(child: Icon(Icons.error_outline)),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                post.title ?? "No Title", // Use post.title
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                post.description ?? "No Description", // Use post.description
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}