import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  const CommonButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: child);
  }
}
class CommonTextButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  const CommonTextButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: child);
  }
}
