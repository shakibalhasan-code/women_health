import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import '../../../controller/language_controller.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});
  final LanguageController languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('select_language')), // Translatable text
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Obx(
                  () => ListTile(
                title: Text("English"),
                trailing: Radio<String>(
                  value: "English",
                  groupValue: languageController.selectedLanguage.value,
                  onChanged: (value) {
                    languageController.changeLanguage(value!, context);
                  },
                ),
              ),
            ),
            Obx(
                  () => ListTile(
                title: Text("Bangla"),
                trailing: Radio<String>(
                  value: "Bangla",
                  groupValue: languageController.selectedLanguage.value,
                  onChanged: (value) {
                    languageController.changeLanguage(value!, context);
                  },
                ),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  context.tr('save'),
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
