import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_services.dart';
import '../core/models/user_model.dart';

class ProfileController extends GetxController {
  var isNotificationEnabled = true.obs;

  Rx<ProfileModel?> profile = ProfileModel().obs;
  RxBool isLoading = true.obs;
  final changePasswordFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final loadedProfile = await ApiService.getProfile();
      if (loadedProfile != null) {
        profile.value = loadedProfile;
      } else {
        Get.snackbar('Error', 'Failed to load profile.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error loading profile: $e');
    } finally {
      isLoading.value = false;
    }
  }
}