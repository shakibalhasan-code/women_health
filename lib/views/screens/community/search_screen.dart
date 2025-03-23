import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/community_controller.dart';
import 'package:women_health/views/screens/community/community_post_details_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final CommunityController communityController =
  Get.find<CommunityController>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Community Posts"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search posts...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
              onChanged: (query) {
                communityController.searchPosts(query);
              },
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(
                    () => communityController.isSearchLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : (communityController.searchQuery.value.isNotEmpty &&
                    communityController.searchResults.isEmpty)
                    ? const Center(child: Text("No posts found."))
                    : ListView.builder(
                  itemCount:
                  communityController.searchResults.length,
                  itemBuilder: (context, index) {
                    final post =
                    communityController.searchResults[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: ListTile(
                        title: Text(post.title ?? "No Title"),
                        subtitle: Text(
                            post.description ?? "No Description"),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.network(
                            post.image ??
                                'https://via.placeholder.com/50', // Placeholder image
                            width: 50.w,
                            height: 50.h,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return Container(
                                width: 50.w,
                                height: 50.h,
                                color: Colors.grey.shade200,
                                child:
                                const Icon(Icons.error_outline),
                              );
                            },
                          ),
                        ),
                        onTap: () {
                          // Navigate to post details
                          // Example:
                          Get.to(CommunityPostDetailsScreen(post: post));
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}