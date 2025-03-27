import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:women_health/core/models/product_model.dart';
import 'package:women_health/utils/constant/app_theme.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductItem({Key? key, required this.product, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
              child: Image.network(
                product.images[0], // Replace with your image URL
                height: 120.h, // Keep this for consistency
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120.h,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.error_outline),
                  );
                },
              ),
            ),
            Expanded( // Use Expanded to dynamically fill remaining space
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space evenly
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      product.description,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '\৳${product.price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}