import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class CardWithIcon extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  const CardWithIcon({Key? key,required this.title,required this.subtitle,required this.icon,required this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
      Container(
        height: 110,
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
            border: Border.all(color: Colors.grey[800]??Colors.grey, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor.withOpacity(0.2)
              ),
              child: Icon(
                icon,
                size: 30,
                color: iconColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
