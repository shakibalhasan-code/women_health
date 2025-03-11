import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QuestionnaireController extends GetxController {
  var currentStep = 1.obs;
  final int totalSteps = 10;

  @override
  void onInit() {
    super.onInit();
    loadResponses(); // Load saved responses on initialization
  }

  void loadResponses() async {
    Map<String, String> savedResponses = await getResponses();
    if (savedResponses.isNotEmpty) {
      selectedAnswers.addAll(savedResponses);
    }
  }

  final List<Map<String, dynamic>> questions = [
    {
      "question": "What is your age group?",
      "options": ["Under 18", "18-25", "26-35", "36-45", "45+"],
    },
    {
      "question": "Common symptoms?",
      "options": ["Cramps 😣", "Mood Swings 🙂", "Bloating 🩸", "None ❌"],
    },
    {
      "question": "Are you trying to conceive?",
      "options": ["Yes", "No"],
    },
    {
      "question": "When was your last period?",
      "options": ["Select date"],
    },
    {
      "question": "How long does your period usually last?",
      "options": ["2-3 Days", "4-5 Days", "6-7 Days", "7+ Days"],
    },
    {
      "question": "Do you want health tips?",
      "options": ["Yes, send me tips", "No, not interested"],
    },
    {
      "question": "How regular is your menstrual cycle?",
      "options": [
        "Regular (28-32 days)",
        "Sometimes irregular",
        "Very irregular"
      ],
    },
    {
      "question":
          "Do you have any existing medical conditions related to your cycle?",
      "options": ["Yes", "No"],
    },
    {
      "question": "What is your pain level?",
      "options": [
        "No Pain 🤗",
        "Mild Pain 😣",
        "Moderate Pain 😢",
        "Severe Pain 😭"
      ],
    },
    {
      "question": "Are you currently on any medication for menstrual health?",
      "options": ["Yes", "No"],
    }
  ];

  var selectedAnswers = <String, String>{}.obs;

  void selectAnswer(String question, String answer) {
    selectedAnswers[question] = answer;
  }

  void nextStep() {
    if (currentStep.value < totalSteps) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    }
  }

  void saveResponses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userResponses", jsonEncode(selectedAnswers));
    print(prefs.getString('userResponses'));
  }

  Future<Map<String, String>> getResponses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString("userResponses");

    if (jsonString != null) {
      Map<String, String> data =
          Map<String, String>.from(jsonDecode(jsonString));
      print(
          "✅Retrieved Responses: $data"); // ✅ Prints the stored answers correctly
      return data;
    } else {
      print("✅No saved responses found."); // ✅ Handles empty case
      return {};
    }
  }
}
