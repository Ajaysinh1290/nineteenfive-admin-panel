import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class MySlider extends StatelessWidget {

  double value;
  Function(double?) onChanged;
  MySlider({Key? key,required this.value,required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.sliderBorderRadius),
          color: Theme.of(context).primaryColor),
      child: Slider(
        value: value,
        min: 0,
        max: 100,
        onChanged: onChanged,
        activeColor: Theme.of(context).accentColor,
        inactiveColor: ColorPalette.grey,
      ),
    );
  }
}
