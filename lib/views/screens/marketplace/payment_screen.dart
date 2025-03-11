import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Payment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
              Text(
                  'Please send the money to +8801812345678 this number and input the details to confirm the order'),
              Row(
                children: [
                  _paymentMethodChip('Bkash', isSelected: true),
                  _paymentMethodChip('Nogod'),
                  _paymentMethodChip('Cash on delivery'),
                ],
              ),
              SizedBox(height: 20.h),
              _buildTextField('Enter your number'),
              SizedBox(height: 10.h),
              _buildTextField('Transaction Number'),
              SizedBox(height: 10.h),
              _buildTextField('Time ( Optional )'),
              SizedBox(height: 10.h),
              _buildNoteField(),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _outlinedButton('Contact us'),
                  _filledButton('Submit'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentMethodChip(String title, {bool isSelected = false}) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Chip(
        label: Text(title),
        backgroundColor: isSelected ? Colors.red : Colors.grey.shade200,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
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
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Note ( Optional )',
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

  Widget _filledButton(String title) {
    return ElevatedButton(
      onPressed: () {},
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
