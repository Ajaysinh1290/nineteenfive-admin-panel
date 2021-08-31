import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/models/order.dart';
import 'package:nineteenfive_admin_panel/models/user_data.dart';
import 'package:nineteenfive_admin_panel/screens/customers/customer_details.dart';
import 'package:nineteenfive_admin_panel/screens/orders/cancel_and_return_screen.dart';
import 'package:nineteenfive_admin_panel/screens/orders/order_address_screen.dart';
import 'package:nineteenfive_admin_panel/screens/orders/order_basic_details.dart';
import 'package:nineteenfive_admin_panel/screens/orders/order_status_screen.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

import 'order_more_details.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;
  final Function() onBackButtonPressed;

  const OrderDetailsScreen(
      {Key? key, required this.order, required this.onBackButtonPressed})
      : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  ScrollController scrollController = ScrollController();
  UserData? userData;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return userData != null
        ? CustomerDetails(
            userData: userData!,
            onBackButtonPressed: () {
              setState(() {
                userData = null;
              });
            },
          )
        : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              bool inRow = constraints.maxWidth > 900;
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Flex(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        direction: MediaQuery.of(context).size.width > 420
                            ? Axis.horizontal
                            : Axis.vertical,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: widget.onBackButtonPressed,
                                  icon: Icon(
                                    Icons.arrow_back_sharp,
                                    size: 24,
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Order',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.order.userId)
                                    .get()
                                    .then((userDataJson) {
                                  setState(() {
                                    if (userDataJson.data() != null) {
                                      userData = UserData.fromJson(
                                          userDataJson.data()!);
                                    }
                                  });
                                });
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(
                                      Constants.dropDownButtonBorderRadius)),
                              child: Text(
                                'Customer Details',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Flex(
                        direction: inRow ? Axis.horizontal : Axis.vertical,
                        children: [
                          Flexible(
                            flex: inRow ? 2 : 0,
                            child: OrderBasicDetails(order: widget.order),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                          ),
                          Flexible(
                              flex: inRow ? 1 : 0,
                              child: OrderAddressScreen(
                                  address: widget.order.address!))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Flex(
                        direction: inRow ? Axis.horizontal : Axis.vertical,
                        children: [
                          Flexible(
                            flex: inRow ? 1 : 0,
                            child: OrderMoreDetails(order: widget.order),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                          ),
                          Flexible(
                              flex: inRow ? 1 : 0,
                              child: OrderStatusScreen(
                                order: widget.order,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (widget.order.productCancel != null ||
                          widget.order.productReturn != null)
                        CancelAndReturnScreen(order: widget.order)
                    ],
                  ),
                ),
              );
            },
          );
  }
}
