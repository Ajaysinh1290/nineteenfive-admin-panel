import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class BasicTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final bool? obscureText;
  final bool? expanded;
  final TextInputType? textInputType;
  final String? suffixText;
  final FocusNode? focusNode;
  final TextCapitalization? textCapitalization;
  final Function(String)? onChanged;
  final bool? enableInteractiveSelection;
  final List<TextInputFormatter>? inputFormatters;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Color? color;
  const BasicTextField(
      {Key? key,
      required this.labelText,
      this.controller,
      this.validator,
      this.expanded,
      this.obscureText,
      this.textInputType,
      this.suffixText,
      this.textCapitalization,
      this.focusNode,
      this.onChanged,
      this.readOnly,
      this.enableInteractiveSelection,
        this.color,
      this.inputFormatters, this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(Constants.textFieldBorderRadius),
      child: TextFormField(
        maxLines: expanded ?? false ? null : 1,
        validator: validator,
        readOnly: readOnly??false,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        autovalidateMode: AutovalidateMode.disabled,
        enableInteractiveSelection: enableInteractiveSelection ?? true,
        focusNode: focusNode,
        controller: controller,
        onChanged: onChanged,
        keyboardType: textInputType ?? TextInputType.name,
        obscureText: obscureText ?? false,
        cursorColor: Theme.of(context).cursorColor,
        decoration: InputDecoration(
            fillColor: color??Theme.of(context).primaryColor,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(Constants.textFieldBorderRadius),
                borderSide: BorderSide(color: color??Theme.of(context).primaryColor)),
            focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(Constants.textFieldBorderRadius),
                borderSide: BorderSide(color: color??Theme.of(context).primaryColor)),
            errorBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(Constants.textFieldBorderRadius),
                borderSide: BorderSide(color: color??Theme.of(context).primaryColor)),
            focusedErrorBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(Constants.textFieldBorderRadius),
                borderSide: BorderSide(color: color??Theme.of(context).primaryColor)),
            suffixStyle: GoogleFonts.openSans(
                fontSize: 20, letterSpacing: 0.5, fontWeight: FontWeight.w500),
            suffixText: suffixText??' ',
            suffixIcon: suffixIcon,
            labelText: labelText,
            labelStyle: Theme.of(context).textTheme.headline6!.copyWith()),
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Theme.of(context).accentColor),
      ),
    );
  }
}

