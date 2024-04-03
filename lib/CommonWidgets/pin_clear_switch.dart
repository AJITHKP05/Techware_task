import 'package:flutter/material.dart';

class PinClearSwitch extends StatefulWidget {
  final Function(bool) onChange;

  const PinClearSwitch({super.key, required this.onChange});
  @override
  _PinClearSwitchState createState() => _PinClearSwitchState();
}

class _PinClearSwitchState extends State<PinClearSwitch> {
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          _switchValue ? 'Keep the PIN ' : 'Clear the PIN ',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 20),
        Switch(
          value: _switchValue,
          onChanged: (value) {
            setState(() {
              _switchValue = value;
             widget. onChange(value);
            });
          },
        ),
      ],
    );
  }
}
