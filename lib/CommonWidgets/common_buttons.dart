import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  const CommonButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}

class CommonButtonText extends StatelessWidget {
  final Function() onPressed;
  final String child;
  const CommonButtonText(
      {super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
      ),
      child: Text(
        child,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class CommonTextButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  const CommonTextButton(
      {super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: child);
  }
}
