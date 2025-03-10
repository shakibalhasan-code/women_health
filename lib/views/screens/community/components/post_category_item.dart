import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:women_health/utils/constant/app_theme.dart';

class PostCategoryItem extends StatelessWidget {
  final bool isSelected;
  final String text;

  const PostCategoryItem(
      {super.key, required this.isSelected, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 12.w, vertical: 6.h), // Add padding
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20.w),
          border: Border.all(
              color: isSelected
                  ? Colors.black
                  : Colors.transparent), // Optional border
        ),
        child: Text(
          text,
          style: AppTheme.titleSmall
              .copyWith(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
