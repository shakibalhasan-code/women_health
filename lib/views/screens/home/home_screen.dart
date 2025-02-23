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
import 'package:women_health/views/screens/edit_period/edit_period_screen.dart';
import 'package:women_health/views/screens/home/components/menstrual_cycle.dart';
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
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20.h),
            Expanded(child: bodyPeriodContainer()),
            _buildGridCards(),
          ],
        ),
      ),
    );
  }

  Widget bodyPeriodContainer() {
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            MenstrualCyclePhaseView(
              size: 250.h,
              theme: MenstrualCycleTheme.arcs,
              phaseTextBoundaries: PhaseTextBoundaries.outside,
              isRemoveBackgroundPhaseColor: true,
              viewType: MenstrualCycleViewType.text,
              isAutoSetData: false,
            ),
             SizedBox(height: 15.h,),
            SizedBox(width: 200.w,
            child: OutlinedButton(onPressed: ()=> Get.to(EditPeriodScreen()), child: Text('Edit Period')),
            )
          ]
              ),
      ),
    );
  }

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
                "Your next period on 26 Feb",
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

  Widget _buildGridCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: HomeCardWidget(
                  iconPath: AppIcons.communityIcon,
                  title: 'Community Forum',
                  subTitle: 'Conversation & take control of your health',
                  cardColor: Colors.blue.withOpacity(0.1),
                  borderColor: AppTheme.blue,
                  iconColor: AppTheme.blue,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: HomeCardWidget(
                  iconPath: AppIcons.shopIcon,
                  title: 'Shopping',
                  subTitle: 'From here now',
                  cardColor: AppTheme.primaryColor.withOpacity(0.2),
                  borderColor: AppTheme.primaryColor,
                  iconColor: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            children: [

              Expanded(
                child: HomeCardWidget(
                  iconPath: AppIcons.mentalHealthIcon,
                  title: 'Mental Health Counselling',
                  subTitle: 'Expert guidance for your well-being',
                  cardColor: AppTheme.yelloward,
                  borderColor: Colors.yellow,
                  iconColor: Colors.yellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

