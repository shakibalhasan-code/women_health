import 'package:get/get.dart';

class MarketplaceController extends GetxController {
  var productCategories = <String>['Test1', 'Test2', 'Test3', 'Test4', 'Test5']
      .obs; // ✅ Make it reactive

  var selectedCategoryIndex = 0.obs; // ✅ Observable variable
}
