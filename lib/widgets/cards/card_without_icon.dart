import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class CardWithoutIcon extends StatelessWidget {
  final String title;
  final String subtitle;

  const CardWithoutIcon({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 110,
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
            border: Border.all(color: Colors.grey[800] ?? Colors.grey, width: 1)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontFamily: GoogleFonts.openSans().fontFamily
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
