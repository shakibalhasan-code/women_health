import 'package:get/get.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget_base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class UserHelper extends GetxService {
  var lastPeriodDate = ''.obs;
  var periodDuration = 5.obs;
  var cycleLength = 28.obs;

  var completedQuestion = 2.obs;
  final instance = MenstrualCycleWidget.instance!;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final responsesString = prefs.getString('userResponses');

    if (responsesString != null) {
      final responses = jsonDecode(responsesString) as Map<String, dynamic>;

      // Extract data from responses and update the observables
      // This assumes that your SharedPreferences contains keys named "How long does your period usually last?", "How regular is your menstrual cycle?", "When was your last period?"
      // Adapt these lines based on your actual data structure
      final periodDurationResponse = responses["How long does your period usually last?"];
      if (periodDurationResponse != null) {
        // Convert period duration to number of days (example)
        if(periodDurationResponse == "2-3 Days"){
          periodDuration.value = 3; //use 3 for consistency
        }
        else if(periodDurationResponse == "4-5 Days"){
          periodDuration.value = 5; //use 5 for consistency
        }
        else if(periodDurationResponse == "6-7 Days"){
          periodDuration.value = 7; //use 7 for consistency
        }
        else{
          periodDuration.value = 8; //For "7+ Days", use 8
        }
      }

      final cycleLengthResponse = responses["How regular is your menstrual cycle?"];
      if (cycleLengthResponse != null) {
        // Customize cycle length (example)
        if(cycleLengthResponse == "Regular (28-32 days)"){
          cycleLength.value = 30; //Use 30 as standard
        }
        else{
          cycleLength.value = 28; //set 28 as default
        }

      }

      final lastPeriodDateResponse = responses["When was your last period?"];
      if (lastPeriodDateResponse != null) {
        lastPeriodDate.value = lastPeriodDateResponse;
      }

      // After all the response are set, then initialized
      instance.updateConfiguration(cycleLength: cycleLength.value, periodDuration: periodDuration.value);
    } else {
      print("No user responses found in SharedPreferences");
    }
  }

  void incrementStep() {
    if (completedQuestion < 10) {
      completedQuestion.value++;
    }
  }

  void decrementStep() {
    if (completedQuestion.value > 1) {
      completedQuestion.value--;
    }
  }

  static Future<void> openEmail(String email)async {
    if (!await launchUrl(Uri.parse('mailto:$email'))) {
      throw Exception('Could not launch email');
    }
  }

  static Future<void> makeCall(String number) async {
    final Uri url = Uri.parse('tel:$number'); // Correct scheme is 'tel:'

    if (!await launchUrl(url)) {
      throw Exception('Could not launch call');
    }
  }
}