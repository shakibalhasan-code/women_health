import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final numberController = TextEditingController();
  final transactionController = TextEditingController();
  final timeController = TextEditingController();
  final noteController = TextEditingController();

  var selectedPaymentMethod = 'Bkash'.obs;
  final List<String> paymentMethods = ['Bkash', 'Nagod', 'Cash on delivery'];

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void copyNumber() {
    Clipboard.setData(ClipboardData(text: "+8801812345678"));
    Get.snackbar("Copied", "Number copied to clipboard");
  }

  void submitPayment() {
    if (formKey.currentState!.validate()) {
      Get.snackbar("Success", "Payment details submitted successfully");
      // Handle submission logic here
    }
  }

  @override
  void onClose() {
    numberController.dispose();
    transactionController.dispose();
    timeController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
