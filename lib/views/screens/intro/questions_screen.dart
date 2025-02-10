import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:women_health/core/helper/user_info_helper.dart';
import 'package:women_health/views/glob_widgets/global_question_container.dart';
import 'package:women_health/views/glob_widgets/my_button.dart';
import 'package:women_health/views/screens/tab/tab_screen.dart';
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
          padding:  EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Positioned(
                left: 10,
                right: 10,
                top: 10,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(()=> Text(_userInformation.completedQuestion.value <=5 ? 'About You' : 'Almost done',style: AppTheme.titleMedium)),
                      const Spacer(),
                      TextButton(
                        onPressed: (){},
                          child: Text('skip',style: AppTheme.titleSmall.copyWith(color: Colors.grey)))
                  ],),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(AppTheme.defaultRadius), topRight: Radius.circular(AppTheme.defaultRadius)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///step progress
                      Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(AppTheme.defaultRadius),topRight: Radius.circular(AppTheme.defaultRadius)),
                            color: AppTheme.secondColor.withOpacity(0.8)
                          ),
                          child: Obx(()=> Stack(
                            children: [
                              LinearProgressIndicator(
                                color: Colors.grey,
                                backgroundColor: AppTheme.secondColor.withOpacity(0.3),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(AppTheme.defaultRadius),topRight: Radius.circular(AppTheme.defaultRadius)),
                                minHeight: double.infinity, // This makes the indicator fill the height of its parent
                                value: _userInformation.completedQuestion.value.toDouble() /10, // value between 0.0 and 1.0
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.secondColor), // Use AlwaysStoppedAnimation for a constant color
                              ),
                              Center(child: Text('${_userInformation.completedQuestion} of 10',style: AppTheme.titleMedium.copyWith(color: Colors.white,fontWeight: FontWeight.bold)))

                            ],
                          ))
                      ), ///end of progress step

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            MyGlobalQuestionContainer(
                                question: 'What is your gender?',
                                child: SizedBox(
                                  height: 25,
                                  child: ListView.builder(
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context,index){
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(5),
                                            onTap: (){

                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                                                  border: Border.all(color: Colors.grey,width: 1)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(3),
                                                child: Text('Under-18',style: AppTheme.titleSmall.copyWith(color: AppTheme.black400)),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ), isDone: false),
                            const SizedBox(height: 5,),
                            MyGlobalQuestionContainer(
                                question: 'When was your last period?',
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                                border: Border.all(color: Colors.grey,width: 1)
                                      ),
                                    )
                                  ],
                                ), isDone: true),
                            const SizedBox(height: 5,),

                            MyGlobalQuestionContainer(
                                question: 'What is your gender?',
                                child: Row(
                                  children: [

                                  ],
                                ), isDone: true),

                          ],
                        ),
                      )

                      ],
                  ),
                  ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: MyButton(onTap: (){
                  Get.to(()=> TabScreen());
                }, child: Text('Continue')),
              ),
              const SizedBox(height: 10,)

            ],
          ),
        ),
      ),
    );
  }
}
