import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class SimpleOrderStatusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double? height;

  SimpleOrderStatusCard({Key? key, required this.title, required this.subtitle,this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height??60,
      width: double.infinity,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: Theme.of(context).textTheme.headline5,),
          Text(subtitle,style: Theme.of(context).textTheme.headline6,),
        ],
      ),
    );
  }
}
