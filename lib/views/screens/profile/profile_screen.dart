import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/profile_controller.dart';
import 'package:women_health/views/screens/profile/about_us.dart';
import 'package:women_health/views/screens/profile/change_password.dart';
import 'package:women_health/views/screens/profile/language_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        leading: SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20.r)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        NetworkImage("https://via.placeholder.com/150"),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "John Doe",
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "johndoe@example.com",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      profileStat("25", "Post"),
                      profileStat("120", "Likes"),
                      profileStat("30", "Comments"),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _followStat("72", "Followers"),
                      SizedBox(width: 20.w),
                      _followStat("52", "Following"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            profileOption(Icons.language, "Language",
                onTap: () => Get.to(LanguageScreen())),
            Obx(
              () => profileOption(
                Icons.notifications,
                "Notification",
                trailing: Switch(
                  value: profileController.isNotificationEnabled.value,
                  onChanged: (bool value) {
                    profileController.isNotificationEnabled.value = value;
                  },
                  activeColor: Colors.red,
                ),
              ),
            ),
            profileOption(Icons.info, "About us",
                onTap: () => Get.to(AboutUsScreen())),
            profileOption(Icons.lock, "Change password",
                onTap: () => Get.to(ChangePasswordScreen())),
            profileOption(Icons.logout, "Log out",
                color: Colors.red, onTap: () => _showLogoutDialog(context)),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout logic here
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget profileStat(String value, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 4.h),
          Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _followStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
      ],
    );
  }

  Widget profileOption(IconData icon, String title,
      {VoidCallback? onTap, Widget? trailing, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black),
      title: Text(title, style: TextStyle(color: color ?? Colors.black)),
      trailing: trailing ??
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.black),
      onTap: onTap,
    );
  }
}
