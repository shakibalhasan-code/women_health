import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:women_health/utils/constant/app_theme.dart';

class AuthIconWidget extends StatelessWidget {
  final String iconPath;
  const AuthIconWidget({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 111.w,
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primaryColor),
        borderRadius: BorderRadius.circular(20.r)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(iconPath,color: AppTheme.primaryColor),
      ),
    );
  }
}
