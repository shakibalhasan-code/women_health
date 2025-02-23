import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/utils/constant/route.dart';
import 'package:women_health/views/glob_widgets/my_button.dart';
import 'package:women_health/views/screens/auth/widgets/auth_icon_widget.dart';

import '../../../utils/constant/app_icons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 15.h
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome Back',style: AppTheme.titleMedium.copyWith(color: AppTheme.secondColor)),
                  SizedBox(height: 5.h),
                  Text('Login Here',style: AppTheme.titleLarge.copyWith(color: AppTheme.primaryColor)),
                  SizedBox(height: 15.h),

                  TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                      )),
                  SizedBox(height: 5.h,),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  SizedBox(height: 15.h,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: ()=>  Get.toNamed('/forget'),child: Text('Forget password?',style: AppTheme.titleSmall.copyWith(color: AppTheme.primaryColor)))
                    ],
                  ),
                  SizedBox(height: 5.h),
                  MyButton(onTap: (){
                    Get.toNamed(AppRoute.tab);
                  }, child: Text('SignIn')),
                  SizedBox(height: 10.h,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: ()=> Get.toNamed('/signup'), child: Text('Don\'t have any account ? Create Now',style: AppTheme.titleSmall.copyWith(color: AppTheme.primaryColor)))
                    ],
                  )
                ],
              ),
            ),
            Text('or Login with',style: AppTheme.titleSmall),
            SizedBox(height: 8.h,),
            Row(
             mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AuthIconWidget(iconPath: AppIcons.googleIcon),
                SizedBox(width: 8.w),
                AuthIconWidget(iconPath: AppIcons.fbIcon),
              ],)
          ],
        )
      ),
    );
  }
}
