// views/screens/marketplace/components/product_item.dart
import 'package:cached_network_image/cached_network_image.dart'; // Import the package
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:women_health/core/models/product_model.dart'; // Ensure this path is correct
import 'package:women_health/utils/constant/app_theme.dart'; // Ensure AppTheme has primaryColor, titleSmall, titleMedium

class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  // Define your base URL for images if product.images contains relative paths
  // If product.images already contains full URLs, you can set this to an empty string
  // or remove the concatenation later.
  final String imageBaseUrl = 'http://178.16.137.209:5000/'; // Example base URL

  const ProductItem({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  String _getImageUrl(String imagePath) {
    // Check if the imagePath is already a full URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    // Otherwise, prepend the base URL
    return imageBaseUrl + imagePath;
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = product.images.isNotEmpty
        ? _getImageUrl(product.images[0]) // Use the helper to get full URL
        : 'https://via.placeholder.com/150?text=No+Image'; // Fallback URL

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3.0,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Make image stretch
          children: [
            Expanded(
              flex: 3, // Image takes more space
              child: Hero(
                tag:
                    'product-image-${product.id}', // Unique tag for Hero animation
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12.r)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: Center(
                          child: Icon(Icons.broken_image_outlined,
                              color: Colors.grey[400], size: 40.sp)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTheme.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\৳${product.price.toStringAsFixed(2)}', // Format price
                    style: AppTheme.titleMedium.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
