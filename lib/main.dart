import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:menstrual_cycle_widget/menstrual_cycle_widget_base.dart';
import 'package:women_health/utils/constant/app_constant.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/utils/constant/binding.dart';
import 'package:women_health/utils/constant/route.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // InitializationStatus status = await MobileAds.instance.initialize();
  // if(status.adapterStatuses.)

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // Add the initialization code with your OneSignal App ID
  OneSignal.initialize(AppConstant.onesignal_key);
  // Use this method to prompt for push notifications
  // We recommend removing this method after testing and instead use In-App Messages to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);

  MenstrualCycleWidget.init(
    secretKey: "w4rvj53boj53oc92lus2uq6r",
    ivKey: "1w0mv7gldel0mcpecdnjt409",
  );

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', ''), Locale('bn', '')],
      path: 'assets/lang', // Ensure this folder contains JSON language files
      fallbackLocale: Locale('en', ''),
      saveLocale: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Women Health",
          locale: context.locale, // Set locale dynamically
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          theme: AppTheme.theme,
          initialBinding: InitialBinding(),
          initialRoute: AppRoute.splash,
          getPages: AppRoute.pages,
          home: child,
        );
      },
    );
  }
}
