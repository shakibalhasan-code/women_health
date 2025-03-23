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
      appBar: WidgetHelper.showAppBar(title: 'Marketplace', isBack: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose category',
              style: AppTheme.titleMedium.copyWith(color: Colors.black),
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
                        onTap: () => marketplaceController.setSelectedCategory(categoryName, index), // Pass category name
                        categoryName: categoryName,
                        isSelected: index == marketplaceController.selectedCategoryIndex.value,
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
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: List.generate(
                          marketplaceController.products.length,
                              (index) {
                            final product = marketplaceController.products[index];
                            return SizedBox(
                              width: 180.w, // Fixed width for each product item
                              child: ProductItem(
                                product: product,
                                onTap: () {
                                  Get.to(() => ProductDetailsScreen(product: product));
                                },
                              ),
                            );
                          },
                        ),
                      ),
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
}