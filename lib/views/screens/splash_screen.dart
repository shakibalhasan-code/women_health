import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_health/controller/auth_controller.dart';
import 'package:women_health/controller/intro_controller/intro_controller.dart'; // Import the QuestionnaireController
import 'package:women_health/views/screens/auth/login_screen.dart';
import 'package:women_health/views/screens/intro/questions_screen.dart';
import 'package:women_health/views/screens/tab/tab_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.find();
  final QuestionnaireController questionnaireController =
      Get.find(); // Get QuestionnaireController

  @override
  void initState() {
    super.initState();
    _checkAppStatus(); // Combined check
  }

  Future<void> _checkAppStatus() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate loading time

    final token = await authController.getTokenFromPrefs();

    if (token != null && token.isNotEmpty) {
      // User has a token, assume they are logged in

      await questionnaireController.loadResponses(); // Load saved responses

      bool allQuestionsAnswered = questionnaireController.questions.every(
          (question) => questionnaireController.selectedAnswers
              .containsKey(question['question']));

      if (allQuestionsAnswered) {
        // Questions have been answered, navigate to TabScreen
        Get.offAll(() => TabScreen());
      } else {
        // Questions haven't been answered, navigate to QuestionnaireScreen
        Get.offAll(() => QuestionnaireScreen());
      }
    } else {
      // User is not logged in (no token)
      Get.offAll(() => LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Your splash screen UI
      ),
    );
  }
}
