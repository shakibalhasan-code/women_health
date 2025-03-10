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
import 'package:women_health/views/glob_widgets/my_button.dart';
import 'package:women_health/views/screens/community/components/post_category_item.dart';
import 'package:women_health/views/screens/community/components/post_item.dart';

import '../../../utils/helper/widget_helper.dart';

class CommunityScreen extends StatelessWidget {
  CommunityScreen({super.key});

  final comunityController = Get.find<CommunityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header_section(),
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
          SizedBox(
            width: double.infinity,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Write here',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget header_section() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: Row(
          children: [
            Container(
              width: 150.w,
              decoration: BoxDecoration(
                  color: Color(0xffF4F4F4),
                  borderRadius: BorderRadius.circular(20.r)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
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
            const Spacer(),
            SvgPicture.asset(
              AppIcons.saveIcon,
              color: Colors.black,
            ),
            SvgPicture.asset(
              AppIcons.personIcon,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
