import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';

mixin AppThemeMixin {
  ThemeData get appThemeData => ThemeData(
      primaryColor: ColorPalette.lightBlue,
      scaffoldBackgroundColor: ColorPalette.darkBlue,
      buttonColor: ColorPalette.lightSkyBlue,
      cursorColor: Colors.white,
      fontFamily: GoogleFonts.poppins().fontFamily,
      accentColor: Colors.white,
      highlightColor: Colors.white,
      disabledColor: ColorPalette.grey,
      cardColor: ColorPalette.extraLightBlue,
      dividerColor: Colors.grey[800],
      splashColor: Colors.transparent,
      errorColor: ColorPalette.red,
      scrollbarTheme: ScrollbarThemeData()
          .copyWith(thumbColor: MaterialStateProperty.all(Colors.white24)),
      textTheme: TextTheme(
        caption: GoogleFonts.poppins(
            fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w500),
        bodyText1: GoogleFonts.poppins(
            color: ColorPalette.primaryFontColor,
            letterSpacing: 0.7,
            fontSize: 22,
            fontWeight: FontWeight.w500),
        bodyText2: GoogleFonts.poppins(
            color: ColorPalette.primaryFontColor,
            letterSpacing: 0.5,
            fontSize: 20,
            fontWeight: FontWeight.w400),
        headline1: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: ColorPalette.primaryFontColor,
            fontSize: 30,
            letterSpacing: 1),
        headline2: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: ColorPalette.primaryFontColor,
            fontSize: 24,
            letterSpacing: 1),
        headline3: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: ColorPalette.primaryFontColor,
            fontSize: 18,
            letterSpacing: 1),
        headline4: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: ColorPalette.primaryFontColor,
            fontSize: 20,
            letterSpacing: 1),
        headline5: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: ColorPalette.primaryFontColor,
            fontSize: 16,
            letterSpacing: 1),
        headline6: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: ColorPalette.secondaryFontColor,
            fontSize: 14,
            letterSpacing: 1),
      ));
}
