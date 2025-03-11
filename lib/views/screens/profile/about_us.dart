import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
                children: [
                  TextSpan(
                    text: "At ",
                  ),
                  TextSpan(
                    text: "Nirbhoya",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        " we are dedicated to empowering women with the tools and knowledge to take control of their health and well-being. Our platform provides a safe space for tracking menstrual cycles, accessing expert health insights, and engaging with a supportive community.\n\nWe believe in breaking stigmas, fostering conversations, and offering reliable resources to help women make informed decisions about their bodies. Whether it's period tracking, mental health support, or connecting with others, we are here to support every step of your journey.\n\nJoin us in creating a healthier, more informed future for all women. 💜✨",
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Contact With Us",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            ListTile(
              leading: Icon(Icons.call, color: Colors.green),
              title: Text("Call now"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.call, color: Colors.green),
              title: Text("What's app"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.email, color: Colors.black),
              title: Text("Email"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
