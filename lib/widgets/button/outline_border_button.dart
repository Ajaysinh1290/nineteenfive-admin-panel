import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class OutlineBorderButton extends StatelessWidget {

  final Function() onPressed;
  final String text;
  OutlineBorderButton({Key? key,required this.onPressed,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: Theme.of(context).accentColor,
          ),
          borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }
}
