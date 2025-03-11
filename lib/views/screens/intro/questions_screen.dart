import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_health/controller/intro_controller/intro_controller.dart';
import 'package:women_health/utils/constant/app_theme.dart';
import 'package:women_health/views/glob_widgets/my_button.dart';
import 'package:women_health/views/glob_widgets/global_question_container.dart';
import 'package:women_health/views/screens/tab/tab_screen.dart';

class QuestionnaireScreen extends StatelessWidget {
  QuestionnaireScreen({super.key});
  final QuestionnaireController controller = Get.put(QuestionnaireController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Obx(
          () => Text(
            controller.currentStep.value <= 5 ? 'About You' : 'Almost Done',
            style: AppTheme.titleMedium,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              controller.saveResponses();
              Get.to(() => TabScreen());
            },
            child: Text("Skip", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppTheme.defaultRadius),
                topRight: Radius.circular(AppTheme.defaultRadius),
              ),
              color: AppTheme.secondColor.withOpacity(0.8),
            ),
            child: Obx(
              () => Stack(
                children: [
                  LinearProgressIndicator(
                    color: Colors.grey,
                    backgroundColor: AppTheme.secondColor.withOpacity(0.3),
                    minHeight: double.infinity,
                    value: controller.currentStep.value.toDouble() /
                        controller.totalSteps,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.secondColor),
                  ),
                  Center(
                    child: Text(
                      '${controller.currentStep.value} of ${controller.totalSteps}',
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Obx(
                () {
                  if (controller.questions.isEmpty) {
                    return Center(child: Text("Loading questions..."));
                  }
                  if (controller.currentStep.value - 1 >=
                      controller.questions.length) {
                    return Center(child: Text("No more questions"));
                  }

                  var questionData =
                      controller.questions[controller.currentStep.value - 1];
                  if (questionData == null ||
                      !questionData.containsKey("question")) {
                    return Center(child: Text("Invalid question data"));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyGlobalQuestionContainer(
                        question: questionData["question"],
                        isDone: controller.selectedAnswers
                            .containsKey(questionData["question"]),
                        child: (questionData["question"] ==
                                "When was your last period?")
                            ? GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                  );
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    controller.selectAnswer(
                                        questionData["question"],
                                        formattedDate);
                                  }
                                },
                                child: Obx(
                                  () => Text(
                                    controller.selectedAnswers[
                                            questionData["question"]] ??
                                        "Select date",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: controller.selectedAnswers
                                              .containsKey(
                                                  questionData["question"])
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            : Wrap(
                                spacing: 8.0,
                                children: List.generate(
                                  questionData["options"]?.length ?? 0,
                                  (index) {
                                    String option =
                                        questionData["options"][index];
                                    return Obx(
                                      () => ChoiceChip(
                                        label: Text(option),
                                        selected: controller.selectedAnswers[
                                                questionData["question"]] ==
                                            option,
                                        selectedColor: Colors.red,
                                        onSelected: (selected) {
                                          controller.selectAnswer(
                                              questionData["question"], option);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: MyButton(
                          onTap: () {
                            if (controller.currentStep.value <
                                controller.totalSteps) {
                              controller.nextStep();
                            } else {
                              controller.saveResponses();
                              Get.to(() => TabScreen());
                            }
                          },
                          child: Text("Next"),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
