import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/community_controller.dart';
import 'package:women_health/utils/constant/app_icons.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/utils/constant/route.dart';
import 'package:women_health/views/screens/community/components/post_category_item.dart';
import 'package:women_health/views/screens/community/search_screen.dart';
import 'components/post_item.dart';
import 'saved_post.dart';

class CommunityScreen extends StatelessWidget {
  final bool? isBack;

  CommunityScreen({super.key, this.isBack});

  final communityController = Get.find<CommunityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isBack == true ? AppBar() : null,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (communityController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerSection(context),
                postSection(),
                SizedBox(height: 8.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      communityController.categories.length,
                      (index) {
                        final category = communityController.categories[index];
                        return GestureDetector(
                          onTap: () {
                            communityController.setSelectedCategory(category);
                          },
                          child: PostCategoryItem(
                            isSelected:
                                communityController.selectedCategory.value ==
                                    category,
                            text: category,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Expanded(child: Obx(() {
                  final filteredPosts = communityController.getFilteredPosts();
                  return ListView.builder(
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) {
                      return CommunityPostItem(post: filteredPosts[index]);
                    },
                  );
                })),
              ],
            );
          }
        }),
      ),
    );
  }

  Widget postSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Create Post',
              style: AppTheme.titleMedium.copyWith(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () => Get.toNamed(AppRoute.newPost),
            child: SizedBox(
              width: double.infinity,
              child: TextField(
                enabled: false,
                decoration: const InputDecoration(
                  hintText: 'Write here',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget headerSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: Row(
          children: [
            InkWell(
              onTap: () => Get.to(SearchScreen()),
              child: Container(
                width: 150.w,
                decoration: BoxDecoration(
                    color: const Color(0xffF4F4F4),
                    borderRadius: BorderRadius.circular(20.r)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: Colors.black),
                      SizedBox(width: 5.w),
                      Text('Search',
                          style:
                              AppTheme.titleSmall.copyWith(color: Colors.black))
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => SavedPostsScreen(),
                );
              },
              child: SvgPicture.asset(
                AppIcons.saveIcon,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
