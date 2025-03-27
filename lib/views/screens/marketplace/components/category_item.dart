import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:women_health/utils/constant/app_constant.dart';
import 'package:women_health/utils/constant/app_theme.dart';

class CategoryItem extends StatelessWidget {
  final String categoryName;
  final bool isSelected;
  final VoidCallback onTap;
  const CategoryItem(
      {super.key,
      required this.categoryName,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(AppConstant.categoryRadius)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
            child: Text(categoryName,
                style: AppTheme.titleMedium
                    .copyWith(color: isSelected ? Colors.white : Colors.black)),
          ),
        ),
      ),
    );
  }
}
