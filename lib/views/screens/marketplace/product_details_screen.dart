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
  int _quantity = 1; // Initialize quantity to 1

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
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image (Display Selected Image)
            AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  widget.product.images.isNotEmpty
                      ? widget.product.images[_selectedImageIndex]
                      : 'https://via.placeholder.com/300',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Image List
            SizedBox(
              height: 80.h, // Adjust height as needed
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.product.images.length,
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageIndex = index;
                      });
                    },
                    child: Container(
                      width: 80.w, // Adjust width as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: _selectedImageIndex == index
                              ? AppTheme.primaryColor
                              : Colors.grey.shade300,
                          width: 1.5.w,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: Image.network(
                          widget.product.images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.error));
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Product Name
            SizedBox(height: 10.h),
            Text(
              widget.product.name,
              style: AppTheme.titleMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),

            // Category
            Text(
              'Category: ${widget.product.category.name}',
              style: AppTheme.titleMedium.copyWith(color: Colors.grey[700]),
            ),
            SizedBox(height: 16.h),

            // Price
            Text(
              '\৳${widget.product.price.toStringAsFixed(2)}',
              style: AppTheme.titleSmall.copyWith(
                  color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),

            // Description
            Text(
              widget.product.description,
              style: AppTheme.titleSmall,
            ),

            // Quantity Section
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity:',
                  style: AppTheme.titleSmall,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: _decreaseQuantity,
                    ),
                    Text(
                      _quantity.toString(),
                      style: AppTheme.titleMedium,
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _increaseQuantity,
                    ),
                  ],
                ),
              ],
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => PaymentScreen(
                    product: widget.product,
                    quantity: _quantity,
                  ));
                },
                child: Text('Buy Now'),
              ),
            )
          ],
        ),
      ),
    );
  }
}