import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  var selectedLanguage = 'English'.obs;
}

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});
  final LanguageController languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Language"),
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
                    languageController.selectedLanguage.value = value!;
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
                    languageController.selectedLanguage.value = value!;
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
                  "Save",
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
