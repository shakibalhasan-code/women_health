import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/views/glob_widgets/my_button.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: ()=> Get.back(), icon: Icon(Icons.arrow_back_ios_new_rounded,color: AppTheme.primaryColor,)),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 15.h
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Reset Your Password',style: AppTheme.titleLarge.copyWith(color: AppTheme.primaryColor)),
            Text('We will send an OTP to you email address',style: AppTheme.titleSmall.copyWith(color: Colors.black)),
            SizedBox(height: 15.h),
            TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                )),
            SizedBox(height: 20.h),
            MyButton(onTap: ()=> Get.toNamed('/verify'), child: Text('Continue')),
            SizedBox(height: 10.h,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: ()=>  Get.toNamed('/login'), child: Text('Login Now',style: AppTheme.titleSmall.copyWith(color: AppTheme.primaryColor)))

              ],
            )
          ],
        ),
      ),
    );
  }
}
