import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/marketplace_controller.dart';
import 'package:women_health/utils/helper/widget_helper.dart';
import 'package:women_health/views/screens/marketplace/components/category_item.dart';
import 'package:women_health/views/screens/marketplace/components/product_item.dart';

class MarketplaceScreen extends StatelessWidget {
  MarketplaceScreen({super.key});
  final marketplaceController = Get.find<MarketplaceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.showAppBar(title: 'Marketplace', isBack: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            SizedBox(height: 10.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Obx(() {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: marketplaceController.productCategories.length,
                    itemBuilder: (context, index) {
                      return ProductItem();
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
