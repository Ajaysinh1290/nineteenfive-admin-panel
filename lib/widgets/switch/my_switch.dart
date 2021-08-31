import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';

class MySwitch extends StatelessWidget {
  final Function(bool) onChanged;
  final bool value;

  const MySwitch({Key? key, required this.onChanged, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch(
        value: value,
        activeColor: Colors.white,
        activeTrackColor: ColorPalette.skyBlue,
        inactiveTrackColor: Colors.grey.withOpacity(0.3),
        onChanged: (value) {
          onChanged.call(value);
        });
  }
}
