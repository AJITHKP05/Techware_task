// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../Utils/toast.dart';
import 'common_buttons.dart';

class PinLoginPrompt extends StatefulWidget {
  const PinLoginPrompt({super.key, required this.onLogin});
  final Function(String) onLogin;

  @override
  _PinLoginPromptState createState() => _PinLoginPromptState();
}

class _PinLoginPromptState extends State<PinLoginPrompt> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      decoration: BoxDecoration(
        color: const Color.fromARGB(94, 14, 74, 193),
        borderRadius: BorderRadius.circular(24),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return AlertDialog(
      title: const Text('Login using PIN'),
      content: SizedBox(
        height: 200,
        child: Pinput(
          length: 4,
          controller: controller,
          focusNode: focusNode,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          defaultPinTheme: defaultPinTheme,
          separatorBuilder: (index) => const SizedBox(width: 16),
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                  offset: Offset(0, 3),
                  blurRadius: 16,
                ),
              ],
            ),
          ),
          // onClipboardFound: (value) {
          //   debugPrint('onClipboardFound: $value');
          //   controller.setText(value);
          // },
          showCursor: true,
          cursor: cursor,
        ),
      ),
      actions: [
        CommonTextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CommonButton(
          child: const Text("Set"),
          onPressed: () {
            if (controller.text.length == 4) {
              widget.onLogin(controller.text);
            } else {
              successToast("Please enter PIN");
            }
          },
        ),
      ],
    );
  }
}
