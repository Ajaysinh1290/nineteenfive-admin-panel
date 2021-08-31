import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/firebase/database/firebase_database.dart';
import 'package:nineteenfive_admin_panel/firebase/notification/notification_service.dart';
import 'package:nineteenfive_admin_panel/models/order.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_admin_panel/widgets/cards/simple_order_status_card.dart';
import 'package:nineteenfive_admin_panel/widgets/dialog/my_dialog.dart';

class OrderStatusScreen extends StatefulWidget {
  final Order order;

  const OrderStatusScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  Widget getOrderStatusWidget(
      String title, DateTime? date, bool enabled, Function()? onPressed) {
    return date == null
        ? LongBlueButton(
            onPressed: enabled
                ? () {
                    if (onPressed != null) {
                      onPressed.call();
                      NotificationService.sendNotification(widget.order.userId, "Nineteenfive", "Your order is "+title.toLowerCase(), {
                        "screen" : "order_status_screen",
                        "order_id" : widget.order.orderId
                      });
                    }
                  }
                : null,
            text: title,
            height: 70,
            color: enabled
                ? Theme.of(context).buttonColor
                : Theme.of(context).buttonColor.withOpacity(0.5),
          )
        : SimpleOrderStatusCard(
            title: title,
            height: 70,
            subtitle: Constants.onlyDateFormat.format(date),
          );
  }

  storeOrder(BuildContext context) async {
    MyDialog.showLoading(context);
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.order.orderId)
        .set(widget.order.toJson());
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool inRow = constraints.maxWidth > 420;
        return Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius:
                  BorderRadius.circular(Constants.containerBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  offset: Offset(1, 2),
                  blurRadius: 20,
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Status',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 35,
              ),
              Flex(
                direction: inRow ? Axis.horizontal : Axis.vertical,
                children: [
                  Flexible(
                      flex: inRow ? 1 : 0,
                      child: getOrderStatusWidget(
                          "Order Placed", widget.order.orderTime, true, null)),
                  SizedBox(
                    width: 15,
                    height: 15,
                  ),
                  Flexible(
                      flex: inRow ? 1 : 0,
                      child: getOrderStatusWidget(
                          "Shipped",
                          widget.order.shippingTime,
                          widget.order.productCancel == null, () {
                        widget.order.shippingTime = DateTime.now();
                        storeOrder(context);
                      }))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Flex(
                direction: inRow ? Axis.horizontal : Axis.vertical,
                children: [
                  Flexible(
                      flex: inRow ? 1 : 0,
                      child: getOrderStatusWidget(
                          "Out For Delivery",
                          widget.order.outForDeliveryTime,
                          widget.order.shippingTime != null, () {
                        widget.order.outForDeliveryTime = DateTime.now();
                        storeOrder(context);
                      })),
                  SizedBox(
                    width: 15,
                    height: 15,
                  ),
                  Flexible(
                      flex: inRow ? 1 : 0,
                      child: getOrderStatusWidget(
                          "Delivered",
                          widget.order.deliveryTime,
                          widget.order.outForDeliveryTime != null, () {
                        widget.order.deliveryTime = DateTime.now();
                        storeOrder(context);
                      }))
                ],
              ),
              if (widget.order.productReturn != null)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Flex(
                    direction: inRow ? Axis.horizontal : Axis.vertical,
                    children: [
                      Flexible(
                          flex: inRow ? 1 : 0,
                          child: getOrderStatusWidget(
                              "Product Picked Up",
                              widget.order.productReturn!.productPickupTime,
                              widget.order.deliveryTime != null, () {
                            widget.order.productReturn!.productPickupTime =
                                DateTime.now();
                            storeOrder(context);
                          })),
                      SizedBox(
                        width: 15,
                        height: 15,
                      ),
                      Flexible(
                          flex: inRow ? 1 : 0,
                          child: getOrderStatusWidget(
                              "Product Received Back",
                              widget.order.productReturn!.productReceivedTime,
                              widget.order.productReturn!.productPickupTime !=
                                  null, () {
                            widget.order.productReturn!.productReceivedTime =
                                DateTime.now();
                            storeOrder(context);
                          }))
                    ],
                  ),
                ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
