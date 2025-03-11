import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:women_health/controller/intro_controller/payment_controller.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});
  final PaymentController controller = Get.put(PaymentController());

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
                    controller.numberController, 'Enter your number'),
                SizedBox(height: 10.h),
                _buildTextField(
                    controller.transactionController, 'Transaction ID'),
                SizedBox(height: 10.h),
                _buildTimePickerField(context),
                SizedBox(height: 10.h),
                _buildNoteField(),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _outlinedButton('Contact us'),
                    _filledButton('Submit',
                        onPressed: controller.submitPayment),
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

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
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

  Widget _buildTimePickerField(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          String formattedTime = pickedTime.format(context);
          controller.timeController.text = formattedTime;
        }
      },
      child: AbsorbPointer(
        child: _buildTextField(controller.timeController, 'Select Time'),
      ),
    );
  }

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
}
