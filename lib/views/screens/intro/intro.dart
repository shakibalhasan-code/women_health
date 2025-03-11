import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:women_health/utils/constant/app_constant.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/views/glob_widgets/my_button.dart';
import 'package:women_health/views/screens/auth/login_screen.dart';
import 'package:women_health/views/screens/intro/questions_screen.dart';

class IntroFirstScreen extends StatelessWidget {
  const IntroFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              )),
          Expanded(
            flex: 1,
            child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.bluebg,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppTheme.defaultRadius),
                      topRight: Radius.circular(AppTheme.defaultRadius)),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Welcome to',
                                style: AppTheme.titleMedium
                                    .copyWith(color: AppTheme.secondColor)),
                            Text('Nirbhoya',
                                style: AppTheme.titleLarge
                                    .copyWith(color: AppTheme.primaryColor)),
                            const SizedBox(height: 50),
                            Text(
                              'Track your cycle with accuracy and understand your body\'s natural rhythm.',
                              style: AppTheme.titleMedium
                                  .copyWith(color: Colors.black26),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 15,
                          child: MyButton(
                              onTap: () {
                                Get.to(() => LoginScreen());
                              },
                              child: Text('Get Started')))
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
