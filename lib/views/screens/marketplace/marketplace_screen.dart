import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/marketplace_controller.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/utils/helper/widget_helper.dart';
import 'package:women_health/views/screens/marketplace/components/category_item.dart';
import 'package:women_health/views/screens/marketplace/components/product_item.dart';
import 'package:women_health/views/screens/marketplace/product_details_screen.dart';

class MarketplaceScreen extends StatelessWidget {
  MarketplaceScreen({Key? key}) : super(key: key);

  final marketplaceController = Get.find<MarketplaceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Lighter background
      appBar: WidgetHelper.showAppBar(title: 'Marketplace', isBack: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 16.w, top: 16.h, bottom: 8.h, right: 16.w),
            child: Text(
              'Categories',
              style: AppTheme.titleMedium.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp),
            ),
          ),
          Obx(() {
            if (marketplaceController.isLoading.value &&
                marketplaceController.categories.isEmpty) {
              return SizedBox(
                height: 50.h,
                child: const Center(
                    child: Text("Loading categories...",
                        style: TextStyle(color: Colors.grey))),
              );
            }
            if (marketplaceController.categories.isEmpty) {
              return const SizedBox.shrink();
            }
            return SizedBox(
              height: 50.h, // Fixed height for the category list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                itemCount: marketplaceController.categories.length,
                itemBuilder: (context, index) {
                  final categoryName = marketplaceController.categories[index];
                  return CategoryItem(
                    onTap: () => marketplaceController.setSelectedCategory(
                        categoryName, index),
                    categoryName: categoryName,
                    isSelected: index ==
                        marketplaceController.selectedCategoryIndex.value,
                  );
                },
              ),
            );
          }),
          Padding(
            padding: EdgeInsets.only(
                left: 16.w, top: 16.h, bottom: 8.h, right: 16.w),
            child: Text(
              'Products',
              style: AppTheme.titleMedium.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (marketplaceController.isLoading.value &&
                  marketplaceController.products.isEmpty) {
                return Center(
                    child: CircularProgressIndicator(
                        color: AppTheme.primaryColor));
              } else if (marketplaceController.products.isEmpty) {
                return Center(
                  child: Text(
                    'No products found.',
                    style: AppTheme.titleSmall
                        .copyWith(color: Colors.grey[600], fontSize: 16.sp),
                  ),
                );
              } else {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _calculateCrossAxisCount(context),
                      // Adjust aspect ratio based on ProductItem design.
                      // (width / height). A taller card means a smaller aspect ratio.
                      childAspectRatio: 0.7, // Might need adjustment
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    itemCount: marketplaceController.products.length,
                    itemBuilder: (context, index) {
                      final product = marketplaceController.products[index];
                      return ProductItem(
                        product: product,
                        onTap: () {
                          Get.to(() => ProductDetailsScreen(product: product));
                        },
                      );
                    },
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 600) {
      // For tablets or wider screens
      return 3;
    } else {
      // For phones
      return 2;
    }
  }
}
