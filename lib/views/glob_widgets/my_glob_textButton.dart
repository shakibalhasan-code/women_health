import 'package:flutter/material.dart';
import 'package:women_health/utils/constant/app_theme.dart';

class MyGlobTextbutton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const MyGlobTextbutton(
      {super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {},
          child: Text(buttonText,
              style: AppTheme.titleMedium
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold))),
    );
  }
}
