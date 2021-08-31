import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/models/order.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_admin_panel/widgets/dialog/my_dialog.dart';

class CancelAndReturnScreen extends StatefulWidget {
  final Order order;

  const CancelAndReturnScreen({Key? key, required this.order})
      : super(key: key);

  @override
  State<CancelAndReturnScreen> createState() => _CancelAndReturnScreenState();
}

class _CancelAndReturnScreenState extends State<CancelAndReturnScreen> {
  BankDetails? bankDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.order.productCancel != null) {
      bankDetails = widget.order.productCancel!.bankDetails;
    } else {
      bankDetails = widget.order.productReturn!.bankDetails;
    }
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
              '${widget.order.productCancel != null ? "Cancellation" : "Return"}' +
                  ' Details',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '${widget.order.productCancel != null ? "Cancellation" : "Return Request"} Time',
                    style: Theme.of(context).textTheme.headline3),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(
                      Constants.dateFormat.format(
                          (widget.order.productCancel != null
                                  ? widget.order.productCancel!.cancellationTime
                                  : widget.order.productReturn!
                                      .returnRequestTime) ??
                              DateTime.now()),
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
                Text(
                    '${widget.order.productCancel != null ? "Cancellation" : "Return"} Reason',
                    style: Theme.of(context).textTheme.headline3),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(
                      (widget.order.productCancel != null
                              ? widget.order.productCancel!.cancelReason
                              : widget.order.productReturn!.returnReason) ??
                          '',
                      style: Theme.of(context).textTheme.headline5),
                )
              ],
            ),
            if (widget.order.productReturn != null)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Qty To Return',
                        style: Theme.of(context).textTheme.headline3),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                          widget.order.productReturn!.numberOfItems.toString(),
                          style: Theme.of(context).textTheme.headline5),
                    )
                  ],
                ),
              ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Bank Details',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Account Holder Name',
                    style: Theme.of(context).textTheme.headline3),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(bankDetails!.accountHolderName,
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
                Text('Account Number',
                    style: Theme.of(context).textTheme.headline3),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(bankDetails!.accountNumber,
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
                Text('IFSC Code', style: Theme.of(context).textTheme.headline3),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(bankDetails!.ifscCode,
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontFamily: GoogleFonts.openSans().fontFamily)),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            widget.order.productReturn != null &&
                        widget.order.productReturn!.refundTime != null ||
                    widget.order.productCancel != null &&
                        widget.order.productCancel!.refundTime != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Refund Time',
                          style: Theme.of(context).textTheme.headline3),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Text(
                            Constants.dateFormat
                                .format((widget.order.productReturn != null
                                        ? (widget
                                            .order.productReturn!.refundTime)
                                        : (widget.order.productCancel!
                                            .refundTime)) ??
                                    DateTime.now())
                                .toString(),
                            style: Theme.of(context).textTheme.headline5),
                      )
                    ],
                  )
                : LongBlueButton(
                    onPressed: () {
                      widget.order.productReturn!.refundTime = DateTime.now();
                      storeOrder(context);
                    },
                    text: 'Proceed Refund',
                  ),
          ],
        ));
  }
}
