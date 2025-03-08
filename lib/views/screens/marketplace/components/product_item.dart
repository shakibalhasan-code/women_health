import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/views/glob_widgets/my_glob_textButton.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    'https://media.cdn-jaguarlandrover.com/api/v2/images/55880/w/680.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text('X-corolla', style: AppTheme.titleMedium),
            Text('Toyota',
                style: AppTheme.titleSmall.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            MyGlobTextbutton(buttonText: 'Buy Now', onTap: () {})
          ],
        ),
      ),
    );
  }
}
