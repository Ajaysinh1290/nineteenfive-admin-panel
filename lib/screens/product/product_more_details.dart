import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/models/product.dart';
import 'package:nineteenfive_admin_panel/models/user_data.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/widgets/cards/card_with_icon.dart';
import 'package:nineteenfive_admin_panel/widgets/grid_view/responsive_grid_view_for_cards.dart';
import 'package:nineteenfive_admin_panel/widgets/switch/my_switch.dart';

class ProductMoreDetails extends StatefulWidget {
  final Product product;
  final double? height;

  ProductMoreDetails({Key? key, required this.product, this.height})
      : super(key: key);

  @override
  State<ProductMoreDetails> createState() => _ProductMoreDetailsState();
}

class _ProductMoreDetailsState extends State<ProductMoreDetails> {
  int likes = 0;

  int orders = 0;

  int pendingOrders = 0;

  late ScrollController ratingsController;
  late ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ratingsController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ratingsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveGridViewForCards(
            children: [
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    likes = 0;
                    List data = snapshot.data.docs;
                    data.forEach((element) {
                      UserData userData = UserData.fromJson(element.data());
                      if (userData.likedProducts != null &&
                          userData.likedProducts!
                              .contains(widget.product.productId)) {
                        likes++;
                      }
                    });
                  }
                  return CardWithIcon(
                    subtitle: 'Likes',
                    iconColor: ColorPalette.skyBlue,
                    icon: CupertinoIcons.heart_fill,
                    title: formatNumber(likes).toString(),
                  );
                },
              ),
              CardWithIcon(
                subtitle: 'Stock Left',
                iconColor: ColorPalette.blue,
                icon: Icons.shopping_bag,
                title: formatNumber(widget.product.availableStock).toString(),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('product_id', isEqualTo: widget.product.productId)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data.docs;
                    orders = data.length;
                  }
                  return CardWithIcon(
                    subtitle: 'Orders',
                    iconColor: ColorPalette.green,
                    icon: CupertinoIcons.bag_fill,
                    title: formatNumber(orders).toString(),
                  );
                },
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('product_id', isEqualTo: widget.product.productId)
                    .where('delivery_time', isNull: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data.docs;
                    pendingOrders = data.length;
                  }
                  return CardWithIcon(
                    subtitle: 'Pending Orders',
                    iconColor: ColorPalette.yellow,
                    icon: CupertinoIcons.clock_fill,
                    title: formatNumber(pendingOrders).toString(),
                  );
                },
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(Constants.containerBorderRadius),
                color: Theme.of(context).primaryColor),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    MySwitch(
                        value: widget.product.isFeatured,
                        onChanged: (value) async {
                          widget.product.isFeatured = value;
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc('${widget.product.productId}')
                              .set(widget.product.toJson());
                          setState(() {});
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    MySwitch(
                        value: widget.product.isActive,
                        onChanged: (value) async {
                          widget.product.isActive = value;
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc('${widget.product.productId}')
                              .set(widget.product.toJson());
                          setState(() {});
                        })
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Ratings',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Constants.containerBorderRadius),
                  color: Theme.of(context).primaryColor),
              child: widget.product.productRatings!.length == 0
                  ? Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No Ratings Found',
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      controller: ratingsController,
                      itemCount: widget.product.productRatings!.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget
                                      .product.productRatings![index].userId)
                                  .get(),
                              builder: (context, AsyncSnapshot snapshot) {
                                String userName = '';
                                if (snapshot.hasData) {
                                  userName = snapshot.data.data()['user_name'];
                                }
                                return Text(
                                  userName,
                                  style: Theme.of(context).textTheme.headline5,
                                );
                              },
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: ColorPalette.yellow,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    widget.product.productRatings![index].rating
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.headline5)
                              ],
                            )
                          ],
                        );
                      }),
            ),
          )
        ],
      ),
    );
  }
}
