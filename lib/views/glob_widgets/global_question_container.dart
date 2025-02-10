import 'package:flutter/material.dart';
import 'package:women_health/utils/constant/app_theme.dart';

class MyGlobalQuestionContainer extends StatelessWidget {
  final Widget child;
  final bool isDone;
  final String question;
  const MyGlobalQuestionContainer({super.key, required this.child, required this.isDone, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDone ? AppTheme.secondTransColor: AppTheme.blue50,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurStyle: BlurStyle.solid,
            blurRadius: 2
          )
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question,style: AppTheme.titleMedium.copyWith(color: AppTheme.black400)),
                const SizedBox(height: 5),
                child
              ],
            ))
          ],
        ),
      ),
    );
  }
}
