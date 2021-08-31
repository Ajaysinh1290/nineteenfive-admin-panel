import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/models/order.dart';
import 'package:nineteenfive_admin_panel/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/widgets/table/my_table.dart';

class CustomersOrders extends StatelessWidget {
  final UserData userData;

  const CustomersOrders({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            "Orders",
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where("user_id", isEqualTo: userData.userId)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            late List<Order> recentOrders;
            if (snapshot.hasData) {
              List data = snapshot.data.docs;
              recentOrders = [];
              data.forEach((element) {
                recentOrders.add(Order.fromJson(element.data()));
              });
              recentOrders = recentOrders.reversed.toList();
            }
            return !snapshot.hasData
                ? Container()
                : recentOrders.isEmpty
                    ? Container(
                        height: 160,
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(
                                Constants.containerBorderRadius)),
                        child: Text(
                          'No Orders Found',
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : MyTable(
                        columns: List.generate(
                            Constants.ordersTableColumns.length,
                            (index) => DataColumn(
                                    label: Text(
                                  Constants.ordersTableColumns[index],
                                  style: Theme.of(context).textTheme.headline3,
                                ))),
                        rows: List.generate(
                            recentOrders.length,
                            (index) => DataRow(cells: [
                                  DataCell(MouseRegion(
                                    child: Text(
                                      '#${recentOrders[index].orderId}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(color: ColorPalette.blue),
                                    ),
                                    cursor: SystemMouseCursors.click,
                                  )),
                                  DataCell(Text(
                                    Constants.onlyDateFormat
                                        .format(recentOrders[index].orderTime!),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )),
                                  DataCell(
                                    FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(recentOrders[index].userId)
                                          .get(),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        String emailId = '';
                                        if (snapshot.hasData) {
                                          emailId =
                                              snapshot.data.data()['user_name'];
                                        }
                                        return Text(
                                          emailId,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        );
                                      },
                                    ),
                                  ),
                                  DataCell(MouseRegion(
                                    child: Text(
                                      '#${recentOrders[index].productId}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(color: ColorPalette.blue),
                                    ),
                                    cursor: SystemMouseCursors.click,
                                  )),
                                  DataCell(Text(
                                    recentOrders[index]
                                        .numberOfItems
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )),
                                  DataCell(Text(
                                    Constants.currencySymbol +
                                        recentOrders[index]
                                            .totalAmount
                                            .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                            fontFamily: GoogleFonts.openSans()
                                                .fontFamily),
                                  )),
                                ])),
                      );
          },
        )
      ],
    );
  }
}
