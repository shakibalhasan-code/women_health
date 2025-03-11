import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:women_health/utils/constant/app_theme.dart';

class HomeCardWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subTitle;
  final Color cardColor;
  final Color iconColor;
  final Color borderColor;

  const HomeCardWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subTitle,
    required this.cardColor,
    required this.borderColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.5.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                ),
              ],
            ),
            child: SvgPicture.asset(
              iconPath,
              color: iconColor,
              width: 20.w,
              height: 20.h,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            title,
            style: AppTheme.titleMedium.copyWith(
                fontSize: 14.sp,
                color: AppTheme.black400,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              subTitle,
              style: AppTheme.titleSmall
                  .copyWith(fontSize: 10.sp, color: AppTheme.black400),
            ),
          ),
        ],
      ),
    );
  }
}
