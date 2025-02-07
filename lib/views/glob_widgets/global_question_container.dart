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
        color: AppTheme.secondColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.done,color: isDone ? AppTheme.secondColor : Colors.grey),
            const SizedBox(width: 8),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question,style: AppTheme.titleMedium.copyWith(color: AppTheme.secondColor)),
                child
              ],
            ))
          ],
        ),
      ),
    );
  }
}
