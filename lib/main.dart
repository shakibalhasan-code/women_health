import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget_base.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/utils/constant/binding.dart';
import 'package:women_health/utils/constant/route.dart';
import 'package:women_health/views/screens/intro/intro_1.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  MenstrualCycleWidget.init(
      secretKey: "w4rvj53boj53oc92lus2uq6r",
      ivKey: "1w0mv7gldel0mcpecdnjt409"
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoute.intro1,
      getPages: AppRoute.pages,
      theme: AppTheme.theme,
      initialBinding: InitialBinding(),
    );
  }
}

