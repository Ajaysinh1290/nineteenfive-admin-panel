import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/models/order.dart';
import 'package:nineteenfive_admin_panel/models/product.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class OrderMoreDetails extends StatefulWidget {
  final Order order;

  const OrderMoreDetails({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderMoreDetails> createState() => _OrderMoreDetailsState();
}

class _OrderMoreDetailsState extends State<OrderMoreDetails> {
  Product? product;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProduct();
  }

  fetchProduct() async {
    FirebaseFirestore.instance
        .collection('products')
        .doc(widget.order.productId)
        .get()
        .then((value) {
      setState(() {
        product = Product.fromJson(value.data());
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius:
                BorderRadius.circular(Constants.containerBorderRadius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order date',
                    style: Theme.of(context).textTheme.headline3),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(
                      Constants.onlyDateFormat
                          .format(widget.order.orderTime ?? DateTime.now()),
                      style: Theme.of(context).textTheme.headline5),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order id', style: Theme.of(context).textTheme.headline3),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(widget.order.orderId,
                      style: Theme.of(context).textTheme.headline5),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sub total', style: Theme.of(context).textTheme.headline3),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(
                      Constants.currencySymbol +
                          widget.order.totalAmount.toString(),
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontFamily: GoogleFonts.openSans().fontFamily)),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shipping', style: Theme.of(context).textTheme.headline3),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(
                      Constants.currencySymbol +
                          widget.order.shippingCharge.toString(),
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontFamily: GoogleFonts.openSans().fontFamily)),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: Theme.of(context).textTheme.headline3),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(
                      Constants.currencySymbol +
                          (widget.order.totalAmount +
                                  widget.order.shippingCharge!)
                              .toString(),
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontFamily: GoogleFonts.openSans().fontFamily)),
                )
              ],
            ),
            if (widget.order.promoCodeDiscount != null)
              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Promo code',
                          style: Theme.of(context).textTheme.headline3),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Text(
                                (widget.order.promoCode??'').toString()+" (-" +
                                    Constants.currencySymbol +
                                    widget.order.promoCodeDiscount.toString()+")",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    fontFamily:
                                        GoogleFonts.openSans().fontFamily)),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Grand total',
                          style: Theme.of(context).textTheme.headline3),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Text(
                            Constants.currencySymbol +
                                (widget.order.totalAmount +
                                        widget.order.shippingCharge! -
                                        widget.order.promoCodeDiscount!)
                                    .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    fontFamily:
                                        GoogleFonts.openSans().fontFamily)),
                      )
                    ],
                  ),
                ],
              ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transaction id',
                    style: Theme.of(context).textTheme.headline3),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(widget.order.transactionId ?? '',
                      style: Theme.of(context).textTheme.headline5),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order status',
                    style: Theme.of(context).textTheme.headline3),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(
                      widget.order.productReturn != null &&
                              widget.order.productReturn!.productPickupTime !=
                                  null
                          ? "Returned"
                          : widget.order.productCancel != null
                              ? "Cancelled"
                              : widget.order.deliveryTime != null
                                  ? 'Delivered'
                                  : widget.order.outForDeliveryTime != null
                                      ? "Out for delivery"
                                      : widget.order.shippingTime != null
                                          ? "Shipped"
                                          : "Confirmed",
                      style: Theme.of(context).textTheme.headline5),
                )
              ],
            ),
          ],
        ));
  }
}
