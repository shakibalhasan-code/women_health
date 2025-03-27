import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/views/screens/marketplace/payment_screen.dart';
import '../../../core/models/product_model.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300.h,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product-image-${widget.product.id}', // Unique tag for Hero animation
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(12.r)),
                      child: Image.network(
                        widget.product.images.isNotEmpty
                            ? widget.product.images[_selectedImageIndex]
                            : 'https://via.placeholder.com/300',
                        fit: BoxFit.cover,
                        height: 300.h,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail Gallery
                      SizedBox(
                        height: 80.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.product.images.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImageIndex = index;
                                });
                              },
                              child: Container(
                                width: 80.w,
                                margin: EdgeInsets.only(right: 8.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: _selectedImageIndex == index
                                        ? AppTheme.primaryColor
                                        : Colors.grey.shade300,
                                    width: 2.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.network(
                                    widget.product.images[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                          child: Icon(Icons.error));
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Product Details Card
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              widget.product.name,
                              style: AppTheme.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // Category
                            Text(
                              'Category: ${widget.product.category.name}',
                              style: AppTheme.titleMedium.copyWith(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // Price
                            Text(
                              '\৳${(widget.product.price * _quantity).toStringAsFixed(2)}',
                              style: AppTheme.titleLarge.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Description
                            Text(
                              widget.product.description,
                              style: AppTheme.titleSmall.copyWith(
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Quantity Selector
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Quantity',
                                  style: AppTheme.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      child: IconButton(
                                        icon:  Icon(Icons.remove_circle,
                                            color: AppTheme.primaryColor),
                                        onPressed: _decreaseQuantity,
                                      ),
                                    ),
                                    Text(
                                      _quantity.toString(),
                                      style: AppTheme.titleLarge.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      child: IconButton(
                                        icon: Icon(Icons.add_circle,
                                            color: AppTheme.primaryColor),
                                        onPressed: _increaseQuantity,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 80.h), // Space for the floating button
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Buy Now Button
          Positioned(
            bottom: 20.h,
            left: 16.w,
            right: 16.w,
            child: GestureDetector(
              onTap: () {
                Get.to(() => PaymentScreen(
                  product: widget.product,
                  quantity: _quantity,
                ));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart, color: Colors.white),
                    SizedBox(width: 8.w),
                    Text(
                      context.tr('buy_now'),
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}