import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/auth_controller.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/utils/constant/app_icons.dart';
import 'package:women_health/views/screens/auth/forget_pass_screen.dart';
import 'package:women_health/views/screens/auth/sign_up_screen.dart';
import 'package:women_health/views/screens/auth/widgets/auth_icon_widget.dart';
import 'package:women_health/views/screens/intro/questions_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'Welcome Back',
                          style: AppTheme.titleMedium
                              .copyWith(color: AppTheme.secondColor),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Login Here',
                          style: AppTheme.titleLarge
                              .copyWith(color: AppTheme.primaryColor),
                        ),
                        SizedBox(height: 15.h),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 5.h),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.to(() => ForgetScreen()),
                        child: Text(
                          'Forget password?',
                          style: AppTheme.titleSmall
                              .copyWith(color: AppTheme.primaryColor),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Obx(
                        () => ElevatedButton(
                      onPressed: _authController.isLoading.value
                          ? null
                          : () {
                        if (_formKey.currentState!.validate()) {
                          _authController
                              .loginUser(
                            _emailController.text.trim(),
                            _passwordController.text,
                          )
                              .then((_) async {
                            if (await _authController
                                .getTokenFromPrefs() !=
                                null) {
                              Get.off(() => QuestionnaireScreen());
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 12.h),
                        textStyle: TextStyle(fontSize: 16.sp),
                      ),
                      child: _authController.isLoading.value
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Get.to(() => SignUpScreen()),
                        child: Text(
                          'Don\'t have any account? Create Now',
                          style: AppTheme.titleSmall
                              .copyWith(color: AppTheme.primaryColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            // Text('or Login with', style: AppTheme.titleSmall),
            // SizedBox(height: 8.h),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     AuthIconWidget(iconPath: AppIcons.googleIcon),
            //     SizedBox(width: 8.w),
            //     AuthIconWidget(iconPath: AppIcons.fbIcon),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}