import 'package:get/get.dart';
import 'package:women_health/views/screens/auth/forget_pass_screen.dart';
import 'package:women_health/views/screens/auth/login_screen.dart';
import 'package:women_health/views/screens/auth/sign_up_screen.dart';
import 'package:women_health/views/screens/auth/verify_email_otp_screen.dart';
import 'package:women_health/views/screens/community/add_new_post.dart';
import 'package:women_health/views/screens/home/home_screen.dart';
import 'package:women_health/views/screens/intro/intro.dart';
import 'package:women_health/views/screens/marketplace/marketplace_screen.dart';
import 'package:women_health/views/screens/tab/tab_screen.dart';

class AppRoute {
  static String tab = "/tab";
  static String intro1 = "/intro_1";
  static String home = "/home";
  static String login = "/login";
  static String forget = "/forget";
  static String signUp = "/signup";
  static String verify = "/verify";
  static String marketPlace = "/marketPlace";
  static String newPost = "/newPost";

  static List<GetPage> pages = [
    GetPage(name: tab, page: () => TabScreen()),
    GetPage(name: intro1, page: () => IntroFirstScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: forget, page: () => const ForgetScreen()),
    GetPage(name: signUp, page: () => const SignUpScreen()),
    GetPage(name: verify, page: () => const VerifyEmailOtpScreen()),
    GetPage(name: marketPlace, page: () => MarketplaceScreen()),
    GetPage(name: newPost, page: () => CreatePostScreen()),
  ];
}
