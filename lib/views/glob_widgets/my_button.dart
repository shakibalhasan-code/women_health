import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function onTap;
  final Widget child;
  const MyButton({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap != null
          ? () async {
        await onTap!();
      }
          : null,
      child: child,
    );
  }
}
