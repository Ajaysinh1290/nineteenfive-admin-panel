import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class LongBlueButton extends StatelessWidget {
  final GestureTapCallback? onPressed;
  final String? text;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final double? borderRadius;
  final Color? color;
  final EdgeInsets? margin;

  const LongBlueButton(
      {Key? key,
      required this.onPressed,
      this.text,
      this.width,
      this.height,
      this.textStyle,
      this.color,
      this.borderRadius, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: width ?? double.infinity,
          height: height ?? 60,
          margin: margin??EdgeInsets.all(0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color ?? Theme.of(context).buttonColor,
              borderRadius: BorderRadius.circular(
                  borderRadius ?? Constants.buttonBorderRadius)),
          child: Text(
            text ?? '',
            style: textStyle ?? Theme.of(context).textTheme.headline3!.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
