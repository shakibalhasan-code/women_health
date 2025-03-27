import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:menstrual_cycle_widget/ui/menstrual_cycle_phase_view.dart';
import 'package:menstrual_cycle_widget/utils/enumeration.dart';
import 'package:women_health/controller/period_data_controller.dart';
import 'package:women_health/utils/constant/app_icons.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/views/screens/blog/blog_screen.dart';
import 'package:women_health/views/screens/community/comment_screen.dart';
import 'package:women_health/views/screens/community/community_screen.dart';
import 'package:women_health/views/screens/edit_period/edit_period_screen.dart';
import 'package:women_health/views/screens/home/components/menstrual_cycle.dart';
import 'package:women_health/views/screens/marketplace/marketplace_screen.dart';
import 'package:women_health/views/screens/mental_health_couns/meet_counsiler.dart';
import 'package:women_health/views/screens/mental_health_couns/mental_health_counselor.dart';
import 'package:women_health/views/screens/monthly/monthly_screen.dart';

import 'components/home_card_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final periodDataController = Get.find<PeriodDataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // _buildHeader(),
              SizedBox(height: 10.h),
              SizedBox(
                width: 250,
                height: 300,
                child: MenstrualCyclePhaseView(
                  size: 180.h,
                  theme: MenstrualCycleTheme.arcs,
                  phaseTextBoundaries: PhaseTextBoundaries.outside,
                  isRemoveBackgroundPhaseColor: true,
                  viewType: MenstrualCycleViewType.circleText,
                  isAutoSetData: true,
                ),
              ),

              OutlinedButton(
                  onPressed: () => Get.to(EditPeriodScreen()),
                  child: Text(context.tr('edit_period'))),
              SizedBox(height: 10.h),
              _buildGridCards(context),
            ],
          ),
        ),
      ),
    );
  }

  // Widget bodyPeriodContainer() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 10.w),
  //     child: Column(children: [
  //       SizedBox(
  //         height: 15.h,
  //       ),
  //       OutlinedButton(
  //           onPressed: () => Get.to(EditPeriodScreen()),
  //           child: Text('Edit Period'))
  //     ]),
  //   );
  // }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Nirbhoya',
        style: AppTheme.titleLarge,
      ),
      centerTitle: true,
      leading: const SizedBox(),
      // actions: [
      //   IconButton(onPressed: () {}, icon: Icon(Icons.person)),
      // ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.5),
          ],
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications, color: Colors.white),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Set reminder ",
                style: AppTheme.titleSmall.copyWith(color: Colors.white),
              ),
            ],
          ),
          // Spacer(),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
          // ),
        ],
      ),
    );
  }

  Widget _buildGridCards(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Get.to(CommunityScreen(
                  isBack: true,
                )),
                child: Expanded(
                  child: HomeCardWidget(
                    iconPath: AppIcons.communityIcon,
                    title: context.tr('community_forum'),
                    subTitle: context.tr('community_forum_sub'),
                    cardColor: Colors.blue.withOpacity(0.1),
                    borderColor: AppTheme.blue,
                    iconColor: AppTheme.blue,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: InkWell(
                  onTap: () => Get.to(MarketplaceScreen()),
                  child: HomeCardWidget(
                    iconPath: AppIcons.shopIcon,
                    title: context.tr('shopping'),
                    subTitle: context.tr('shopping_sub'),
                    cardColor: AppTheme.primaryColor.withOpacity(0.2),
                    borderColor: AppTheme.primaryColor,
                    iconColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Get.to(MentalHealthScreen()),
                  child: HomeCardWidget(
                    iconPath: AppIcons.mentalHealthIcon,
                    title: context.tr('mental_health'),
                    subTitle: context.tr('mental_health_sub'),
                    cardColor: AppTheme.yelloward,
                    borderColor: Colors.yellow,
                    iconColor: Colors.yellow,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: InkWell(
                  onTap: () => Get.to(BlogScreen()),
                  child: HomeCardWidget(
                    iconPath: AppIcons.newsIcon,
                    title: context.tr('blog'),
                    subTitle: context.tr('blog_sub'),
                    cardColor: AppTheme.greenCard,
                    borderColor: Colors.green,
                    iconColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
