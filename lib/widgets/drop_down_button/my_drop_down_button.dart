import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class MyDropDownButton extends StatelessWidget {
  final Object? value;
  final void Function(Object?)? onChanged;
  final List<DropdownMenuItem<Object>>? items;
  bool? isExpanded;
  double? height;

  MyDropDownButton(
      {Key? key, this.value, this.onChanged, this.items, this.isExpanded,this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(Constants.dropDownButtonBorderRadius),
        color: Theme.of(context).primaryColor,
      ),
      child: DropdownButton<Object>(
          isExpanded: isExpanded ?? false,
          underline: Container(),
          borderRadius:
              BorderRadius.circular(Constants.dropDownButtonBorderRadius),
          dropdownColor: Theme.of(context).primaryColor,
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Colors.white,
          ),
          iconEnabledColor: Colors.white,
          value: value,
          onChanged: onChanged,
          items: items),
    );
  }
}
