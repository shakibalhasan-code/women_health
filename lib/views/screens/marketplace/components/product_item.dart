import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/views/glob_widgets/my_glob_textButton.dart';

class ProductItem extends StatelessWidget {
  final VoidCallback onTap;
  const ProductItem({super.key, required this.onTap});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$25,000',
                  style: AppTheme.titleMedium.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                // MyGlobTextbutton(buttonText: 'Buy Now', onTap: onTap),
              ],
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: onTap, child: Text('Buy Now')))
          ],
        ),
      ),
    );
  }
}
