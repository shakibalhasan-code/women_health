import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:women_health/controller/community_controller.dart';
import 'package:women_health/utils/constant/app_icons.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/utils/constant/route.dart';
import 'package:women_health/views/screens/community/components/post_category_item.dart';
import 'package:women_health/views/screens/community/search_screen.dart';
import 'components/post_item.dart';
import 'saved_post.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class CommunityScreen extends StatelessWidget {
  final bool? isBack;

  CommunityScreen({super.key, this.isBack});
  final communityController = Get.put(CommunityController());

  Future<void> _onRefresh() async {
    // Reload data when the user pulls down to refresh
    await communityController
        .fetchPosts(); // Assuming you have a method to fetch posts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isBack == true ? AppBar() : null,
      backgroundColor: Colors.white,
      // bottomNavigationBar: communityController.bannerAd != null
      //     ? Align(
      //         alignment: Alignment.bottomCenter,
      //         child: SafeArea(
      //           child: SizedBox(
      //             width: communityController.bannerAd!.size.width.toDouble(),
      //             height: communityController.bannerAd!.size.height.toDouble(),
      //             child: AdWidget(ad: communityController.bannerAd!),
      //           ),
      //         ),
      //       )
      //     : SizedBox(),
      body: SafeArea(
        child: Obx(() {
          if (communityController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return CustomRefreshIndicator(
              onRefresh: _onRefresh,
              builder: (context, child, controller) {
                return AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, _) {
                    final showIndicator = controller
                        .isLoading; // Use isLoading instead of isRefreshing

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        if (showIndicator) //Use showIndicator instead of controller.isRefreshing || controller.isLoading
                          CircularProgressIndicator(
                            value: controller.value.clamp(0.0, 1.0),
                          ),
                        Transform.translate(
                          offset: Offset(0, controller.value * 100),
                          child: child,
                        ),
                      ],
                    );
                  },
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerSection(context),
                  postSection(context),
                  SizedBox(height: 8.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        communityController.categories.length,
                        (index) {
                          final category =
                              communityController.categories[index];
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
                    final filteredPosts =
                        communityController.getFilteredPosts();
                    return filteredPosts.isEmpty
                        ? Center(child: Text(context.tr('empty')))
                        : ListView.builder(
                            //Translated "Empty"
                            itemCount: filteredPosts.length,
                            itemBuilder: (context, index) {
                              return CommunityPostItem(
                                  post: filteredPosts[index]);
                            },
                          );
                  })),
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  Widget postSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr('create_post'), //Translated "Create Post"
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
                decoration: InputDecoration(
                  hintText: context.tr('write_here'), //Translated "Write here"
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
                      Text(context.tr('search_post'), //Translated "Search"
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
