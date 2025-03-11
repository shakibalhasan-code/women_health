import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/marketplace_controller.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/utils/helper/widget_helper.dart';
import 'package:women_health/views/screens/marketplace/components/category_item.dart';
import 'package:women_health/views/screens/marketplace/components/product_item.dart';
import 'package:women_health/views/screens/marketplace/payment_screen.dart';
import 'package:women_health/views/screens/marketplace/product_details_screen.dart';

class MarketplaceScreen extends StatelessWidget {
  MarketplaceScreen({super.key});
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
            Text('Chose category',
                style: AppTheme.titleMedium.copyWith(color: Colors.black)),
            SizedBox(height: 5.h),
            Obx(() {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    marketplaceController.productCategories.length,
                    (index) {
                      return CategoryItem(
                        onTap: () => marketplaceController
                            .selectedCategoryIndex.value = index,
                        categoryName:
                            marketplaceController.productCategories[index],
                        isSelected: index ==
                            marketplaceController.selectedCategoryIndex.value,
                      );
                    },
                  ),
                ),
              );
            }),
            SizedBox(height: 5.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount =
                        (constraints.maxWidth ~/ 120).clamp(2, 4);
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.70,
                      ),
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return ProductItem(
                          onTap: () => Get.to(ProductDetailsScreen()),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
