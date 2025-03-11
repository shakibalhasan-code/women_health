import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:heroicons/heroicons.dart';
import 'package:women_health/controller/community_controller.dart';
import 'package:women_health/utils/constant/app_constant.dart';
import 'package:women_health/utils/constant/app_icons.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/utils/constant/route.dart';
import 'package:women_health/views/glob_widgets/my_button.dart';
import 'package:women_health/views/screens/community/components/post_category_item.dart';
import 'package:women_health/views/screens/community/components/post_item.dart';
import 'package:women_health/views/screens/community/matched_following_screen.dart';
import 'package:women_health/views/screens/community/saved_post.dart';
import 'package:women_health/views/screens/community/search_screen.dart';

import '../../../utils/helper/widget_helper.dart';

class CommunityScreen extends StatelessWidget {
  final bool? isBack;
  CommunityScreen({super.key, this.isBack});

  final comunityController = Get.find<CommunityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isBack == true ? AppBar() : null,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header_section(context),
              post_section(),
              SizedBox(height: 8.h),
              Obx(() {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        comunityController.postCategory.length, (index) {
                      final category = comunityController.postCategory[index];
                      return GestureDetector(
                        onTap: () {
                          comunityController.setSelectedCategory(category);
                        },
                        child: PostCategoryItem(
                          isSelected:
                              comunityController.selectedCategory.value ==
                                  category,
                          text: category,
                        ),
                      );
                    }),
                  ),
                );
              }),
              SizedBox(height: 8.h),
              Expanded(
                  child: ListView.builder(
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        return CommunityPostItem();
                      }))
            ],
          ),
        ));
  }

  Widget post_section() {
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
                decoration: InputDecoration(
                  hintText: 'Write here',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget header_section(BuildContext context) {
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
                    color: Color(0xffF4F4F4),
                    borderRadius: BorderRadius.circular(20.r)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: Colors.black),
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
            // InkWell(
            //   onTap: () => Get.to(MatchFollowingScreen()),
            //   child: SvgPicture.asset(
            //     AppIcons.personIcon,
            //     color: Colors.black,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
