import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/models/order.dart';
import 'package:nineteenfive_admin_panel/screens/orders/order_details_screen.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/utils/data/dummy_data.dart';
import 'package:nineteenfive_admin_panel/widgets/drop_down_button/my_drop_down_button.dart';
import 'package:nineteenfive_admin_panel/widgets/table/my_table.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  ScrollController mainScrollController = ScrollController();
  Order? order;
  late int selectedTimeFilter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTimeFilter = 0;
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: order != null
          ? OrderDetailsScreen(
              order: order!,
              onBackButtonPressed: () {
                setState(() {
                  order = null;
                });
              })
          : SingleChildScrollView(
              controller: scrollController,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Flex(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        direction: MediaQuery.of(context).size.width > 420
                            ? Axis.horizontal
                            : Axis.vertical,
                        children: [
                          Text(
                            "Orders",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MyDropDownButton(
                            value: selectedTimeFilter,
                            onChanged: (value) {
                              setState(() {
                                selectedTimeFilter = value as int;
                              });
                            },
                            items: List.generate(Constants.timeFilters.length,
                                (index) {
                              return DropdownMenuItem(
                                value: index,
                                child: Text(
                                  Constants.timeFilters[index]["label"],
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('orders')
                          .where('order_time',
                              isGreaterThanOrEqualTo: DateTime.now().subtract(
                                  Duration(
                                      days: Constants.timeFilters[
                                          selectedTimeFilter]["value"])))

                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        late List<Order> orders;
                        if (snapshot.hasData) {
                          List data = snapshot.data.docs;
                          orders = [];
                          data.forEach((element) {
                            orders.add(Order.fromJson(element.data()));
                          });
                          orders = orders.reversed.toList();
                        }
                        return !snapshot.hasData
                            ? Container(
                                width: double.infinity,
                                height: 400,
                                margin: EdgeInsets.all(20.0),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(
                                        Constants.tableBorderRadius),
                                    border: Border.all(
                                        color: Colors.grey[800] ?? Colors.grey,
                                        width: 1)),
                              )
                            : MyTable(
                                columns: List.generate(
                                    Constants.ordersTableColumns.length,
                                    (index) => DataColumn(
                                            label: Text(
                                          Constants.ordersTableColumns[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                        ))),
                                rows: List.generate(
                                    orders.length,
                                    (index) => DataRow(
                                            onSelectChanged: (selected) {
                                              setState(() {
                                                order = orders[index];
                                              });
                                            },
                                            cells: [
                                              DataCell(Text(
                                                '#${orders[index].orderId}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        color:
                                                            ColorPalette.blue),
                                              )),
                                              DataCell(Text(
                                                Constants.onlyDateFormat.format(
                                                    orders[index].orderTime!),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              )),
                                              DataCell(
                                                FutureBuilder(
                                                  future: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(orders[index].userId)
                                                      .get(),
                                                  builder: (context,
                                                      AsyncSnapshot snapshot) {
                                                    String emailId = '';
                                                    if (snapshot.hasData) {
                                                      emailId = snapshot.data
                                                          .data()['user_name'];
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
                                              DataCell(Text(
                                                '#${orders[index].productId}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        color:
                                                            ColorPalette.blue),
                                              )),
                                              DataCell(Text(
                                                orders[index]
                                                    .numberOfItems
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              )),
                                              DataCell(Text(
                                                '${Constants.currencySymbol}${(orders[index].totalAmount+orders[index].shippingCharge!-(orders[index].promoCodeDiscount??0)).toString()}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        fontFamily: GoogleFonts
                                                                .openSans()
                                                            .fontFamily),
                                              )),
                                            ])),
                              );
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
