import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/views/glob_widgets/my_button.dart';

class VerifyEmailOtpScreen extends StatelessWidget {
  const VerifyEmailOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: ()=> Get.back(), icon: Icon(Icons.arrow_back_ios_new_rounded,color: AppTheme.primaryColor,)),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 25.w,vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Verify your email',style: AppTheme.titleLarge.copyWith(color: AppTheme.primaryColor)),
            SizedBox(height: 5.h),
            Text('We\'ve sent you a OTP code to your email address, please check and enter the otp below',style: AppTheme.titleSmall.copyWith(color: Colors.black)),
             SizedBox(height: 15.h),
            PinCodeTextField(
                appContext: context,
                length: 6, // Number of PIN digits
                onChanged: (value) {
                  print("Changed: $value");
                  // _authController.otp.value = value;

                },
                onCompleted: (value){
                  // _authController.otp.value = value;
                },
                pinTheme: AppTheme.pinTheme,
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 15.h),
            MyButton(onTap: (){}, child: Text('Verify Now')),
            SizedBox(height: 5.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: (){}, child: Text('Didn\'t receive the code? Resend',style: AppTheme.titleSmall.copyWith(color: AppTheme.primaryColor)))

              ],
            )
          ],
        ),
      ),
    );
  }
}
