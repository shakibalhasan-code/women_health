import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:women_health/utils/constant/app_constant.dart';
import 'package:women_health/utils/constant/app_theme.dart';

class IntroFirstScreen extends StatelessWidget {
  const IntroFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            ],
          )),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(AppConstant.defaultRadius), topRight: Radius.circular(AppConstant.defaultRadius)),
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

              ],
            )
          )
        ],
      ),
    );
  }
}
