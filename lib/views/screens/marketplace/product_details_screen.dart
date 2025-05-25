import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/views/screens/marketplace/payment_screen.dart';
import '../../../core/models/product_model.dart'; // Ensure this path is correct

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String heroTag = 'product-image-${widget.product.id}';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320.h, // Slightly more height for image
                pinned: true,
                stretch: true,
                backgroundColor: Colors.white,
                elevation: 1, // Subtle elevation when pinned
                leading: IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 20.sp),
                  ),
                  onPressed: () => Get.back(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: Hero(
                    tag: heroTag,
                    child: (widget.product.images.isNotEmpty)
                        ? Image.network(
                            widget.product.images[_selectedImageIndex],
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.primaryColor),
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                  'https://via.placeholder.com/300x300.png?text=Image+Not+Found',
                                  fit: BoxFit.cover); // Fallback
                            },
                          )
                        : Image.network(
                            // Fallback if product.images is empty
                            'https://via.placeholder.com/300x300.png?text=No+Image',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        widget.product.name,
                        style: AppTheme.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6.h),

                      // Category
                      Text(
                        'Category: ${widget.product.category.name}',
                        style: AppTheme.titleSmall.copyWith(
                          color: Colors.grey[700],
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Thumbnail Gallery (If multiple images exist)
                      if (widget.product.images.length > 1)
                        SizedBox(
                          height: 75.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.product.images.length,
                            itemBuilder: (context, index) {
                              bool isSelected = _selectedImageIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImageIndex = index;
                                  });
                                },
                                child: Container(
                                  width: 75.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.primaryColor
                                          : Colors.grey.shade300,
                                      width: isSelected ? 2.2.w : 1.2.w,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      widget.product.images[index],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                            child: Icon(
                                                Icons.broken_image_outlined,
                                                color: Colors.grey));
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (widget.product.images.length > 1)
                        SizedBox(height: 20.h),

                      // Price
                      Text(
                        '\৳${widget.product.price.toStringAsFixed(2)}', // Unit Price
                        style: AppTheme.titleLarge.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700, // Bolder
                          fontSize: 24.sp, // Larger
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Description Title
                      Text(
                        'Description',
                        style: AppTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        widget.product.description,
                        style: AppTheme.titleSmall.copyWith(
                          color: Colors.grey[800],
                          fontSize: 14.sp,
                          height: 1.5, // For better readability
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Quantity Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quantity',
                            style: AppTheme.titleMedium.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(25.r)),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline,
                                      color: _quantity > 1
                                          ? AppTheme.primaryColor
                                          : Colors.grey,
                                      size: 26.sp),
                                  onPressed: _decreaseQuantity,
                                  splashRadius: 20.r,
                                  padding: EdgeInsets.zero,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  _quantity.toString(),
                                  style: AppTheme.titleMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp),
                                ),
                                SizedBox(width: 8.w),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline,
                                      color: AppTheme.primaryColor,
                                      size: 26.sp),
                                  onPressed: _increaseQuantity,
                                  splashRadius: 20.r,
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: 90.h), // Space for the floating button bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Buy Now Button Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h)
                  .copyWith(
                      bottom: 10.h +
                          MediaQuery.of(context).padding.bottom *
                              0.6), // Handle safe area
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  ),
                ],
                // border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)) // Optional top border
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  Get.to(() => PaymentScreen(
                        product: widget.product,
                        quantity: _quantity,
                      ));
                },
                child: Text(
                  // Using easy_localization and showing total price
                  "${context.tr('buy_now')}  |  \৳${(widget.product.price * _quantity).toStringAsFixed(2)}",
                  style: AppTheme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
