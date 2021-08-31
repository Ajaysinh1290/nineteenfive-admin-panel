import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/models/address.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class OrderAddressScreen extends StatelessWidget {
  final Address address;

  const OrderAddressScreen({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 245,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(Constants.containerBorderRadius)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Address',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 30,),
          Text(
              address.name +
                  "\n" +
                  address.houseNoOrFlatNoOrFloor +
                  " " +
                  address.societyOrStreetName +
                  "\n" +
                  address.landMark +
                  "\n" +
                  address.area +
                  " " +
                  address.city +
                  "\n" +
                  address.state +
                  ", " +
                  address.pinCode,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
