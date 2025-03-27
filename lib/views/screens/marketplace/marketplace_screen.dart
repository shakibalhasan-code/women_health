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
      backgroundColor: Colors.white,
      appBar: WidgetHelper.showAppBar(title: 'Marketplace', isBack: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Choose category',
                style: AppTheme.titleMedium.copyWith(color: Colors.black),
              ),
            ),
            SizedBox(height: 5.h),
            Obx(() {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    marketplaceController.categories.length,
                        (index) {
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
                ),
              );
            }),
            SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                if (marketplaceController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (marketplaceController.products.isEmpty) {
                  return const Center(child: Text('No products found.'));
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _calculateCrossAxisCount(context),
                        childAspectRatio: 0.78, // Adjusted to prevent overflow
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
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return 3;
    } else {
      return 2;
    }
  }
}