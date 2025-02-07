import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:women_health/core/helper/user_info_helper.dart';
import '../../../utils/constant/app_theme.dart';

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _userInformation = Get.find<UserHelper>();
    final screenHeight = MediaQuery.of(context).size.height;



    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top:screenHeight * 0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppTheme.secondColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppTheme.defaultRadius)
                  ),
                  child: Obx(()=> Stack(
                    children: [
                      LinearProgressIndicator(
                        color: Colors.grey,
                        backgroundColor: AppTheme.secondColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                        minHeight: double.infinity, // This makes the indicator fill the height of its parent
                        value: _userInformation.completedQuestion.value.toDouble() /10, // value between 0.0 and 1.0
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.secondColor), // Use AlwaysStoppedAnimation for a constant color
                      ),
                      Center(child: Text('${_userInformation.completedQuestion} of 10',style: AppTheme.titleMedium))

                    ],
                  ))
                )),

              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.secondColor.withOpacity(0.3),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(AppTheme.defaultRadius), topRight: Radius.circular(AppTheme.defaultRadius)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [



                        ],
                    ),
                  ),
                  ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
