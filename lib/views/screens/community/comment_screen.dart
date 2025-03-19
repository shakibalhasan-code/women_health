import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:women_health/controller/community_controller.dart';

class CommentScreen extends StatelessWidget {
  final List<dynamic> comments;
  final String postId;
   CommentScreen({super.key, required this.comments, required this.postId});
   final communityController = Get.find<CommunityController>();
   final commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: comments.length, // Example count
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(Icons.person,
                            size: 20.sp, color: Colors.black),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Unknown User',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.sp),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              comments[index]['commentText'],
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 10.h),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                InkWell(
                  onTap:()async{
                    // if(commentController.text.isNotEmpty){
                    //   await communityController.addComment(postId,commentController.text);
                    // }
                  },
                  child: CircleAvatar(
                    radius: 22.r,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.send, color: Colors.white, size: 20.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
