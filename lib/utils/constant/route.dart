import 'package:get/get.dart';
import 'package:women_health/views/screens/intro/intro_1.dart';

class AppRoute {
  static String intro1 = "/intro_1";
  static String home = "/home";

  static List<GetPage> pages = [
    GetPage(name: intro1, page: ()=> const IntroFirstScreen()),
    GetPage(name: home, page: ()=> const IntroFirstScreen()),
  ];
}