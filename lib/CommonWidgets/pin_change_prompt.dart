// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../BlockPattern/PinSet_cubit/pin_set_cubit.dart';
import '../Utils/toast.dart';
import 'common_buttons.dart';

class PinChangePrompt extends StatefulWidget {
  const PinChangePrompt({super.key});

  @override
  _PinChangePromptState createState() => _PinChangePromptState();
}

class _PinChangePromptState extends State<PinChangePrompt> {
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

    return BlocProvider(
      create: (context) => PinSetCubit(),
      child: Builder(builder: (context) {
        return BlocConsumer<PinSetCubit, PinSetState>(
          listener: (context, state) {
            if (state is PinSetError) {
              successToast("Something went wrong..!");
            }
            if (state is PinSetSuccess) {
              successToast("Successful");
              
            }
          },
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Change PIN'),
              content: SizedBox(
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Set a 4 digit pin for easy login'),
                    const SizedBox(
                      height: 20,
                    ),
                    Pinput(
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
                              color:
                                  Color.fromRGBO(0, 0, 0, 0.05999999865889549),
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
                  ],
                ),
              ),
              actions: [
                if (state is! PinSetLoading)
                  CommonTextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      
                      Navigator.pop(context);
                    },
                  ),
                if (state is PinSetLoading)
                  CommonTextButton(
                    child: const CircularProgressIndicator(),
                    onPressed: () {},
                  )
                else
                  CommonButton(
                    child: const Text("Change"),
                    onPressed: () {
                      if (controller.text.length == 4) {
                        context.read<PinSetCubit>().changePin(controller.text);
                         Navigator.pop(context);
                      } else {
                        successToast("Please enter PIN");
                      }
                    },
                  ),
              ],
            );
          },
        );
      }),
    );
  }
}
