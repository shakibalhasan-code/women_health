import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../constant/app_theme.dart';

class WidgetHelper {
  static AppBar showAppBar({required String title, required bool isBack}) {
    return AppBar(
        title: Text(
          title,
        ),
        leading: isBack
            ? IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppTheme.primaryColor))
            : null);
  }
}
