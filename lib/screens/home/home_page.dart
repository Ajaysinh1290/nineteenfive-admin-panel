import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/models/order.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_admin_panel/widgets/cards/card_with_graph.dart';
import 'package:nineteenfive_admin_panel/widgets/cards/card_with_icon.dart';
import 'package:nineteenfive_admin_panel/widgets/cards/orders_graph.dart';
import 'package:nineteenfive_admin_panel/widgets/grid_view/responsive_grid_view_for_cards.dart';
import 'package:nineteenfive_admin_panel/widgets/table/my_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController mainScrollController = ScrollController();

  StreamController earningsController = StreamController();
  int unfulfilledOrders = 0;

  // int newMessages = 0;
  // late ValueNotifier newMessages;
  int totalEarningsAccordingToSort = 0;
  int totalOrdersAccordingToSort = 0;
  int totalProducts = 0;
  int totalEarnings = 0;
  bool isMessagesLoaded = false;
  List<Order> earningsThisMonth = [];

  late ValueNotifier<List<int>> messages;
  late DateTime oneMonthAgoDate;
  Map<int, int> earningsMap = {};
  Map<int, int> ordersMap = {};
  Map<int, int> totalOrdersMap = {};

  Map ordersGraphFilter = {
    "Today":
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    "One Month": getOneMonthAgoDate(),
    "One Week": getOneWeekAgoDate(),
    "One Year": getOneYearAgoDate()
  };

  late String selectedOrdersGraphFilter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedOrdersGraphFilter = "One Week";
    // newMessages = ValueNotifier(0);
    messages = ValueNotifier([]);
  }

  static DateTime getOneMonthAgoDate() {
    return DateTime(
        DateTime.now().month == 1
            ? DateTime.now().year - 1
            : DateTime.now().year,
        DateTime.now().month == 1 ? 12 : DateTime.now().month - 1,
        DateTime.now().day);
  }

  static DateTime getOneWeekAgoDate() {
    return DateTime.now().subtract(Duration(days: 7));
  }

  static DateTime getOneYearAgoDate() {
    return DateTime(
        DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
  }

  countUnreadMessages(List<String> list) {
    messages.value = [];
    int i = 0;
    list.forEach((element) async {
      messages.value.add(0);
      await countUnreadMessage(element, i++);
    });
  }

  Future<void> countUnreadMessage(String userId, int index) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chat')
        .where('is_send_by_user', isEqualTo: true)
        .where('is_seen_by_receiver', isEqualTo: false)
        .snapshots()
        .listen((event) {
      messages.value[index] = event.docs.length;
      messages.notifyListeners();
    }).asFuture();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      controller: mainScrollController,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                direction: MediaQuery.of(context).size.width > 420
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  Text(
                    "Overview",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
            ),
            ResponsiveGridViewForCards(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('delivery_time', isNull: true)
                      .where('product_cancel', isNull: true)
                      .where('product_return', isNull: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List data = snapshot.data.docs;
                      unfulfilledOrders = data.length;
                    }
                    return CardWithIcon(
                        title: formatNumber(unfulfilledOrders).toString(),
                        subtitle: 'Unfulfilled Orders',
                        icon: CupertinoIcons.bag_fill,
                        iconColor: ColorPalette.yellow);
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List data = snapshot.data.docs;
                      totalProducts = data.length;
                    }
                    return CardWithIcon(
                        title: formatNumber(totalProducts).toString(),
                        subtitle: 'Products',
                        icon: CupertinoIcons.tag_fill,
                        iconColor: ColorPalette.green);
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    List<String> users = [];
                    if (snapshot.hasData) {
                      List data = snapshot.data.docs;
                      data.forEach((element) {
                        if (element.data()['user_id'] != null) {
                          users.add(element.data()['user_id']);
                        }
                      });
                      countUnreadMessages(users);
                    }
                    return ValueListenableBuilder<List<int>>(
                        valueListenable: messages,
                        builder: (context, List<int> value, child) {
                          int newMessages = 0;
                          value.forEach((element) {
                            newMessages += element;
                          });
                          return CardWithIcon(
                              title: newMessages.toString(),
                              subtitle: "New Messages",
                              icon: Icons.messenger,
                              iconColor: ColorPalette.blue);
                        });
                  },
                ),
                SizedBox(),
                SizedBox(),
                SizedBox()
                // StreamBuilder(
                //   stream: FirebaseFirestore.instance
                //       .collection('orders')
                //       .where('product_cancel', isNull: true)
                //       .where('product_return', isNull: true)
                //       .where('order_time',
                //           isGreaterThanOrEqualTo: oneMonthAgoDate)
                //       .snapshots(),
                //   builder: (context, AsyncSnapshot snapshot) {
                //     if (snapshot.hasData) {
                //       List data = snapshot.data.docs;
                //       totalEarningsAccordingToSort = 0;
                //       int total = 0;
                //       data.forEach((element) {
                //         total = element.data()['total_amount'] ?? 0;
                //         totalEarningsAccordingToSort += total;
                //       });
                //     }
                //     return CardWithoutIcon(
                //       title: Constants.currencySymbol +
                //           formatNumber(totalEarningsAccordingToSort).toString(),
                //       subtitle: "Earnings this month",
                //     );
                //   },
                // ),
                // StreamBuilder(
                //   stream: FirebaseFirestore.instance
                //       .collection('orders')
                //       .where("order_time",
                //           isGreaterThanOrEqualTo: oneMonthAgoDate)
                //       .snapshots(),
                //   builder: (context, AsyncSnapshot snapshot) {
                //     if (snapshot.hasData) {
                //       List data = snapshot.data.docs;
                //       totalOrdersAccordingToSort = data.length;
                //     }
                //     return CardWithoutIcon(
                //       title:
                //           formatNumber(totalOrdersAccordingToSort).toString(),
                //       subtitle: "Total orders this month",
                //     );
                //   },
                // ),
                // StreamBuilder(
                //   stream: FirebaseFirestore.instance
                //       .collection('orders')
                //       .where('product_cancel', isNull: true)
                //       .where('product_return', isNull: true)
                //       .snapshots(),
                //   builder: (context, AsyncSnapshot snapshot) {
                //     if (snapshot.hasData) {
                //       List data = snapshot.data.docs;
                //       int total = 0;
                //       totalEarnings = 0;
                //       data.forEach((element) {
                //         total = element.data()['total_amount'];
                //         totalEarnings += total;
                //       });
                //     }
                //     return CardWithoutIcon(
                //       title: Constants.currencySymbol +
                //           formatNumber(totalEarnings).toString(),
                //       subtitle: "Total Earnings",
                //     );
                //   },
                // ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: MediaQuery.of(context).size.width > 900 ? 520 : null,
                width: double.infinity,
                child: Flex(
                  direction: MediaQuery.of(context).size.width < 900
                      ? Axis.vertical
                      : Axis.horizontal,
                  children: [
                    Flexible(
                      flex: MediaQuery.of(context).size.width < 900 ? 0 : 1,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 520),
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('orders')
                                  .where('order_time',
                                      isGreaterThanOrEqualTo: DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          1))
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  totalEarningsAccordingToSort = 0;
                                  earningsMap = {};
                                  List data = snapshot.data.docs;
                                  data.forEach((element) {
                                    Order order =
                                        Order.fromJson(element.data());
                                    if (order.productReturn == null &&
                                        order.productCancel == null) {
                                      if (!earningsMap
                                          .containsKey(order.orderTime!.day)) {
                                        earningsMap[order.orderTime!.day] =
                                            order.totalAmount;
                                      } else {
                                        earningsMap[order.orderTime!.day] =
                                            earningsMap[order.orderTime!.day]! +
                                                order.totalAmount;
                                      }
                                      totalEarningsAccordingToSort +=
                                          order.totalAmount;
                                    }
                                  });
                                }
                                var entries = earningsMap.entries.toList()
                                  ..sort((a, b) => a.key.compareTo(b.key));
                                earningsMap
                                  ..clear()
                                  ..addEntries(entries);
                                ValueNotifier<double> incrementValue =
                                    ValueNotifier<double>(0);

                                num earnings = 0;
                                FirebaseFirestore.instance
                                    .collection('orders')
                                    .snapshots()
                                    .listen((event) {
                                  List data = event.docs;
                                  data.forEach((element) {
                                    Order order =
                                        Order.fromJson(element.data());
                                    if (order.productReturn == null &&
                                        order.productCancel == null) {
                                      earnings =
                                          earnings + element['total_amount'];
                                    }
                                  });
                                  incrementValue.value =
                                      (totalEarningsAccordingToSort /
                                              earnings) *
                                          100;
                                });

                                return !snapshot.hasData
                                    ? Expanded(
                                        child: Container(
                                        height: 300,
                                        color: Theme.of(context).primaryColor,
                                      ))
                                    : ValueListenableBuilder<double>(
                                        valueListenable: incrementValue,
                                        builder:
                                            (context, double value, child) {
                                          return CardWithGraph(
                                              spots: earningsMap.keys
                                                  .map((e) => FlSpot(
                                                      e.toDouble(),
                                                      earningsMap[e]!
                                                          .toDouble()))
                                                  .toList(),
                                              title: formatNumber(
                                                      totalEarningsAccordingToSort)
                                                  .toString(),
                                              subtitle: 'Earnings this month',
                                              increment:
                                                  value.round().toDouble());
                                        });
                              },
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('orders')
                                  .where('order_time',
                                      isGreaterThanOrEqualTo: DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          1))
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  totalOrdersAccordingToSort = 0;
                                  ordersMap = {};
                                  List data = snapshot.data.docs;
                                  data.forEach((element) {
                                    Order order =
                                        Order.fromJson(element.data());
                                    if (!ordersMap
                                        .containsKey(order.orderTime!.day)) {
                                      ordersMap[order.orderTime!.day] = 1;
                                    } else {
                                      ordersMap[order.orderTime!.day] =
                                          ordersMap[order.orderTime!.day]! + 1;
                                    }
                                    totalOrdersAccordingToSort += 1;
                                  });
                                }
                                var entries = ordersMap.entries.toList()
                                  ..sort((a, b) => a.key.compareTo(b.key));
                                ordersMap
                                  ..clear()
                                  ..addEntries(entries);
                                ValueNotifier<double> incrementValue =
                                    ValueNotifier<double>(0);

                                FirebaseFirestore.instance
                                    .collection('orders')
                                    .snapshots()
                                    .listen((event) {
                                  List data = event.docs;

                                  incrementValue.value =
                                      (totalOrdersAccordingToSort /
                                              data.length) *
                                          100;
                                });

                                return !snapshot.hasData
                                    ? Expanded(
                                        child: Container(
                                        height: 300,
                                        color: Theme.of(context).primaryColor,
                                      ))
                                    : ValueListenableBuilder<double>(
                                        valueListenable: incrementValue,
                                        builder:
                                            (context, double value, child) {
                                          return CardWithGraph(
                                              spots: ordersMap.keys
                                                  .map((e) => FlSpot(
                                                      e.toDouble(),
                                                      ordersMap[e]!.toDouble()))
                                                  .toList(),
                                              title: formatNumber(
                                                      totalOrdersAccordingToSort)
                                                  .toString(),
                                              subtitle: 'Orders this month',
                                              increment:
                                                  value.round().toDouble());
                                        });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                        flex: MediaQuery.of(context).size.width < 900 ? 0 : 1,
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          margin: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(
                                  Constants.cardBorderRadius),
                              border: Border.all(
                                  color: Colors.grey[800] ?? Colors.grey,
                                  width: 1)),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('orders')
                                .where("order_time",
                                    isGreaterThanOrEqualTo: ordersGraphFilter[
                                        selectedOrdersGraphFilter])
                                .snapshots(),
                            builder:
                                (context, AsyncSnapshot<dynamic> snapshot) {
                              List<String> titles = [];
                              if (snapshot.hasData) {
                                totalOrdersMap = {};

                                int length = 0;

                                switch (selectedOrdersGraphFilter) {
                                  case "One Week":
                                    length = 7;
                                    break;
                                  case "One Month":
                                    // length = daysInMonth(getOneMonthAgoDate().month, getOneMonthAgoDate().year);
                                    length = 28;
                                    break;
                                  case "Today":
                                    length = 24;
                                    break;
                                  case "One Year":
                                    length = 12;
                                    break;
                                }

                                print('length $length');
                                for (int i = 0; i < length; i++) {
                                  totalOrdersMap[i] = 0;
                                }

                                List data = snapshot.data.docs;
                                int date = 0;
                                data.forEach((element) {
                                  Order order = Order.fromJson(element.data());
                                  print(
                                      '${order.orderTime}-${order.totalAmount}');
                                  int key = 0;
                                  switch (selectedOrdersGraphFilter) {
                                    case "One Week":
                                      key = order.orderTime!.day -
                                          getOneWeekAgoDate().day -
                                          1;
                                      break;
                                    case "One Month":
                                      if (DateTime.now().month !=
                                          order.orderTime!.month) {
                                        date = order.orderTime!.day %
                                            DateTime.now().day;
                                        key = date;
                                      } else {
                                        key = (order.orderTime!.day + date);
                                      }
                                      break;
                                    case "Today":
                                      key = order.orderTime!.hour;
                                      break;
                                    case "One Year":
                                      key = order.orderTime!.month;
                                      break;
                                  }
                                  if (key < 0) key = 0;
                                  if (!totalOrdersMap
                                      .containsKey(key.toString())) {
                                    totalOrdersMap[key] = order.totalAmount;
                                  } else {
                                    totalOrdersMap[key] =
                                        (totalOrdersMap[key.toString()]! +
                                            order.totalAmount);
                                  }
                                });
                                var entries = totalOrdersMap.entries.toList()
                                  ..sort((a, b) => a.key.compareTo(b.key));
                                totalOrdersMap
                                  ..clear()
                                  ..addEntries(entries);

                                print('sorted map : $totalOrdersMap');

                                switch (selectedOrdersGraphFilter) {
                                  case "One Week":
                                    titles = [
                                      "Mon",
                                      "Tue",
                                      "Wed",
                                      "Thu",
                                      "Fri",
                                      "Sat",
                                      "Sun"
                                    ];
                                    break;
                                  case "One Month":
                                    // for (int i = 0; i < 31; i++) {
                                    //   if (i % 5 == 0) {
                                    //     titles.add(i.toString());
                                    //   } else {
                                    //     titles.add('');
                                    //   }
                                    // }
                                    DateTime firstDate = getOneMonthAgoDate();
                                    DateTime lastDate = DateTime.now();
                                    int i = 1;
                                    while (!(firstDate.day >= lastDate.day &&
                                        firstDate.month >= lastDate.month &&
                                        firstDate.year >= lastDate.year)) {
                                      if (i % 4 == 0) {
                                        titles.add(
                                            '${firstDate.day}/${firstDate.month}');
                                      } else {
                                        titles.add('');
                                      }
                                      i++;
                                      firstDate =
                                          firstDate.add(Duration(days: 1));
                                    }
                                    titles.add(
                                        '${lastDate.day}/${lastDate.month}');
                                    break;
                                  case "Today":
                                    for (int i = 0; i < 24; i++) {
                                      if (i % 4 == 0) {
                                        titles.add(i.toString());
                                      } else {
                                        titles.add('');
                                      }
                                    }
                                    break;
                                  case "One Year":
                                    titles = [
                                      "Jan",
                                      "",
                                      "Mar",
                                      "",
                                      "May",
                                      "",
                                      "Jul",
                                      "",
                                      "Sep",
                                      "",
                                      "Nov",
                                      ""
                                    ];
                                    break;
                                }
                              }

                              return !snapshot.hasData
                                  ? Container(
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : Container(
                                      constraints:
                                          BoxConstraints(maxHeight: 700),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: OrdersGraph(
                                              spots: totalOrdersMap.keys
                                                  .map((e) => FlSpot(
                                                      e.toDouble(),
                                                      totalOrdersMap[e]!
                                                          .toDouble()))
                                                  .toList(),
                                              titles: titles,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(5.0),
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius: BorderRadius
                                                  .circular(Constants
                                                      .containerBorderRadius),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: LongBlueButton(
                                                    color:
                                                        selectedOrdersGraphFilter ==
                                                                "Today"
                                                            ? Theme.of(context)
                                                                .buttonColor
                                                            : Theme.of(context)
                                                                .primaryColor,
                                                    text: 'Today',
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedOrdersGraphFilter =
                                                            "Today";
                                                      });
                                                    },
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headline6!
                                                        .copyWith(
                                                            color:
                                                                selectedOrdersGraphFilter ==
                                                                        "Today"
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white),
                                                    margin: EdgeInsets.all(5.0),
                                                    height: 50,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: LongBlueButton(
                                                    color: selectedOrdersGraphFilter ==
                                                            "One Week"
                                                        ? Theme.of(context)
                                                            .buttonColor
                                                        : Theme.of(context)
                                                            .primaryColor,
                                                    text: 'One Week',
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedOrdersGraphFilter =
                                                            "One Week";
                                                      });
                                                    },
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headline6!
                                                        .copyWith(
                                                            color:
                                                                selectedOrdersGraphFilter ==
                                                                        "One Week"
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white),
                                                    margin: EdgeInsets.all(5.0),
                                                    height: 50,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: LongBlueButton(
                                                    color:
                                                        selectedOrdersGraphFilter ==
                                                                "One Month"
                                                            ? Theme.of(context)
                                                                .buttonColor
                                                            : Theme.of(context)
                                                                .primaryColor,
                                                    text: 'One Month',
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedOrdersGraphFilter =
                                                            "One Month";
                                                      });
                                                    },
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headline6!
                                                        .copyWith(
                                                            color: selectedOrdersGraphFilter ==
                                                                    "One Month"
                                                                ? Colors.black
                                                                : Colors.white),
                                                    margin: EdgeInsets.all(5.0),
                                                    height: 50,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: LongBlueButton(
                                                    color: selectedOrdersGraphFilter ==
                                                            "One Year"
                                                        ? Theme.of(context)
                                                            .buttonColor
                                                        : Theme.of(context)
                                                            .primaryColor,
                                                    text: 'One Year',
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedOrdersGraphFilter =
                                                            "One Year";
                                                      });
                                                    },
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headline6!
                                                        .copyWith(
                                                            color:
                                                                selectedOrdersGraphFilter ==
                                                                        "One Year"
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white),
                                                    margin: EdgeInsets.all(5.0),
                                                    height: 50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                            },
                          ),
                        )),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                "Recent Orders",
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .orderBy('order_id', descending: true)
                  .limit(6)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                late List<Order> recentOrders;
                if (snapshot.hasData) {
                  List data = snapshot.data.docs;
                  recentOrders = [];
                  data.forEach((element) {
                    recentOrders.add(Order.fromJson(element.data()));
                  });
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
                                        String userName = '';
                                        if (snapshot.hasData) {
                                          userName =
                                              snapshot.data.data()['user_name'];
                                        }
                                        return Text(
                                          userName,
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
        ),
      ),
    ));
  }
}
