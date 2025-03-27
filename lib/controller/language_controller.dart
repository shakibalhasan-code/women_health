import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  var selectedLanguage = 'English'.obs;

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language');
    if (savedLanguage != null) {
      selectedLanguage.value = savedLanguage;
      if (savedLanguage == "English") {
        Get.updateLocale(Locale('en', ''));
      } else {
        Get.updateLocale(Locale('bn', ''));
      }
    }
  }

  Future<void> changeLanguage(String language, BuildContext context) async {
    selectedLanguage.value = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);

    if (language == "English") {
      context.setLocale(Locale('en', ''));
      Get.updateLocale(Locale('en', ''));
    } else {
      context.setLocale(Locale('bn', ''));
      Get.updateLocale(Locale('bn', ''));
    }
  }
}