import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/controller/intro_controller/payment_controller.dart';
import 'package:women_health/core/models/product_model.dart';
import 'package:women_health/views/screens/marketplace/thank_you.dart';
import '../../../core/services/api_services.dart';

class PaymentScreen extends StatelessWidget {
  final Product product;
  final int quantity;

  PaymentScreen({Key? key, required this.product, required this.quantity})
      : super(key: key);

  final PaymentController controller = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Details',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                Text('Product Name: ${product.name}'),
                Text('Quantity: $quantity'),
                Text('Price per unit: ৳${product.price.toStringAsFixed(2)}'),
                Text(
                    'Total Price: ৳${(product.price * quantity).toStringAsFixed(2)}'),
                SizedBox(height: 20.h),

                Text(
                  'User Information',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),

                _buildTextField(
                  controller.nameController,
                  'Enter your name',
                      (value) => value == null || value.isEmpty ? 'Name is required' : null,
                ),
                SizedBox(height: 10.h),

                _buildTextField(
                  controller.addressController,
                  'Enter your address',
                      (value) => value == null || value.isEmpty ? 'Address is required' : null,
                ),
                SizedBox(height: 10.h),
                _buildTextField(
                  controller.phoneController,
                  'Enter your phone number',
                      (value) => value == null || value.isEmpty ? 'Phone number is required' : null,
                  keyboardType: TextInputType.phone,
                ),

                SizedBox(height: 20.h),

                Text(
                  'Select Method',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),

                Row(
                  children: controller.paymentMethods.map((method) {
                    return Obx(() => _paymentMethodChip(
                      method,
                      isSelected:
                      controller.selectedPaymentMethod.value == method,
                      onTap: () => controller.selectPaymentMethod(method),
                    ));
                  }).toList(),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: controller.copyNumber,
                  child: Row(
                    children: [
                      Text('Send money to: '),
                      Text(
                        '+8801812345678',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      Icon(Icons.copy, size: 16, color: Colors.blue),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                _buildTextField(
                    controller.numberController, 'Enter your number',
                        (value) => value == null || value.isEmpty ? 'Number is required' : null,
                    keyboardType: TextInputType.phone),

                SizedBox(height: 10.h),
                _buildTextField(
                  controller.transactionController,
                  'Transaction ID',
                      (value) => value == null || value.isEmpty ? 'Transaction ID is required' : null,
                ),

                SizedBox(height: 10.h),
                // _buildTimePickerField(context),
                SizedBox(height: 10.h),
                _buildNoteField(),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _outlinedButton('Contact us'),
                    _filledButton('Submit',
                        onPressed: () => _submitPayment(context)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _paymentMethodChip(String title,
      {bool isSelected = false, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: Chip(
          label: Text(title),
          backgroundColor: isSelected ? Colors.red : Colors.grey.shade200,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, String? Function(String?)? validator, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      validator: validator, // Use the provided validator
      keyboardType: keyboardType, // Use the provided keyboard type
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }


  // Widget _buildTimePickerField(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () async {
  //       TimeOfDay? pickedTime = await showTimePicker(
  //         context: context,
  //         initialTime: TimeOfDay.now(),
  //       );
  //       if (pickedTime != null) {
  //         String formattedTime = pickedTime.format(context);
  //         controller.timeController.text = formattedTime;
  //       }
  //     },
  //     child: AbsorbPointer(
  //       child: _buildTextField(controller.timeController, 'Select Time',
  //               (value) => value == null || value.isEmpty ? 'Time is required' : null),
  //     ),
  //   );
  // }

  Widget _buildNoteField() {
    return Container(
      height: 80.h,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black54),
      ),
      child: TextField(
        controller: controller.noteController,
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Note (Optional)',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _outlinedButton(String title) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        side: BorderSide(color: Colors.red),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.red, fontSize: 16.sp),
      ),
    );
  }

  Widget _filledButton(String title, {required Function() onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
      ),
    );
  }

  // New Submit Payment Function
  Future<void> _submitPayment(BuildContext context) async {
    if (controller.formKey.currentState!.validate()) {
      // Get values from controllers
      final String paymentMethod = controller.selectedPaymentMethod.value;
      final String note = controller.noteController.text;
      final String transactionId = controller.transactionController.text;
      final String name = controller.nameController.text;
      final String address = controller.addressController.text;
      final String phone = controller.phoneController.text;


      // Get user ID from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userId');

      if (userId == null) {
        Get.snackbar('Error', 'User ID not found. Please log in again.');
        return;
      }

      final double totalAmount = product.price * quantity;

      // Construct the request body
      final Map<String, dynamic> requestBody = {
        "userId": userId,
        "products": [
          {
            "productId": product.id,
            "quantity": quantity,
          }
        ],
        "totalAmount": totalAmount,
        "paymentMethod": paymentMethod,
        "note": note,
        "transactionId": transactionId,
        "paymentDetails": {
          "name": name,
          "address": address,
          "phone": phone,
          "bkashNumber": controller.numberController.text
        }
      };

      print('=====>>>>>> $requestBody');


      try {
        final response = await ApiService.placeOrder(requestBody);

        if (response != null) {
          Get.snackbar('Success', 'Payment submitted successfully!');
          Get.off(ThankYouScreen()); // Replace Get.back() with Get.off
        } else {
          Get.snackbar('Error', 'Failed to submit payment. Please try again.');
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred: $e');
      }
    }
  }
}