import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Community Posts"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search posts...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount:
                    10, // Example count, replace with actual search results
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: ListTile(
                      title: Text("Community Post Title $index"),
                      subtitle: Text(
                          "This is a sample description of the community post."),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          'https://media.istockphoto.com/id/1513072392/photo/hands-holding-paper-head-human-brain-with-flowers-self-care-and-mental-health-concept.jpg?s=612x612&w=0&k=20&c=CCzxREX01-dEqN3P_1M1ZrsZeenCxTmDWbp-goLwjMc=',
                          width: 50.w,
                          height: 50.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        // Navigate to post details
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
