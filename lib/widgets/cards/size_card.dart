import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class SizeCard extends StatelessWidget {
  final String? size;
  final bool isSelected;
  final EdgeInsets? margin;
  final Color? selectedItemTextColor;

  const SizeCard(
      {Key? key,
      this.size,
      required this.isSelected,
      this.margin,
      this.selectedItemTextColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        width: size!.length > 2 ? 45 : 35,
        height: 35,
        alignment: Alignment.center,
        margin: margin ?? EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: isSelected?Theme.of(context).buttonColor:Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
        ),
        child: Text(
          size!,
          style: GoogleFonts.openSans(
              fontSize: 14,
              letterSpacing: 1,
              fontWeight: isSelected?FontWeight.bold:FontWeight.w500,
              color: isSelected
                  ? selectedItemTextColor ?? ColorPalette.darkBlue
                  : Colors.white),
        ),
      ),
    );
  }
}
