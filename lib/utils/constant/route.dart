import 'package:get/get.dart';
import 'package:women_health/views/screens/intro/intro_1.dart';
import 'package:women_health/views/screens/tab/tab_screen.dart';

class AppRoute {
  static String tab = "/tab";
  static String intro1 = "/intro_1";
  static String home = "/home";

  static List<GetPage> pages = [
    GetPage(name: tab, page: ()=> TabScreen()),
    GetPage(name: intro1, page: ()=> const IntroFirstScreen()),
    GetPage(name: home, page: ()=> const IntroFirstScreen()),
  ];
}