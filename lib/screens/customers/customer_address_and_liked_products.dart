import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/models/address.dart';
import 'package:nineteenfive_admin_panel/models/product.dart';
import 'package:nineteenfive_admin_panel/models/user_data.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/widgets/image/image_network.dart';

class CustomerAddressAndLikedProducts extends StatelessWidget {
  final UserData userData;
  final ScrollController addressesScrollController = ScrollController();
  final ScrollController likedProductsScrollController = ScrollController();

  CustomerAddressAndLikedProducts({Key? key, required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 650,
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(Constants.containerBorderRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Text(
              'Addresses',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          userData.addresses == null || userData.addresses!.isEmpty
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
                    'No Address Found',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    GestureDetector(
                      onHorizontalDragUpdate: (value) {
                        if (addressesScrollController.hasClients) {
                          addressesScrollController.jumpTo(
                              addressesScrollController.offset -
                                  (value.primaryDelta ?? 0));
                        }
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: addressesScrollController,
                        child: Row(
                          children: List.generate(userData.addresses!.length,
                              (index) {
                            Address address = userData.addresses![index];
                            return Container(
                              height: 160,
                              width: 300,
                              margin: EdgeInsets.all(10.0),
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(
                                      Constants.containerBorderRadius)),
                              child: Text(
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
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Text(
              'Liked Products',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          userData.likedProducts == null || userData.likedProducts!.isEmpty
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
                    'No Liked Products Found',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    GestureDetector(
                      onHorizontalDragUpdate: (value) {
                        if (likedProductsScrollController.hasClients) {
                          likedProductsScrollController.jumpTo(
                              likedProductsScrollController.offset -
                                  (value.primaryDelta ?? 0));
                        }
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: likedProductsScrollController,
                        child: Row(
                            children: List.generate(
                                userData.likedProducts!.length, (index) {
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('products')
                                .doc(userData.likedProducts![index])
                                .snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              late Product product;
                              if (snapshot.hasData) {
                                product =
                                    Product.fromJson(snapshot.data.data());
                              }
                              return !snapshot.hasData
                                  ? Container(
                                      width: 200,
                                      height: 300,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Constants.containerBorderRadius),
                                          color: Theme.of(context).cardColor),
                                    )
                                  : GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 200,
                                        height: 300,
                                        margin: const EdgeInsets.all(2.0),
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Constants.cardBorderRadius),
                                            color:
                                                Theme.of(context).primaryColor),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: ImageNetwork(
                                                  imageUrl: product
                                                      .productImages.first,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 90,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product.productName,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${Constants.currencySymbol}${product.productPrice}',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline5!
                                                              .copyWith(
                                                                  fontFamily: GoogleFonts
                                                                          .openSans()
                                                                      .fontFamily),
                                                        ),
                                                        if (product
                                                                .productMrp !=
                                                            null)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5.0),
                                                            child: Text(
                                                              '${Constants.currencySymbol}${product.productMrp}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6!
                                                                  .copyWith(
                                                                      fontFamily:
                                                                          GoogleFonts.openSans()
                                                                              .fontFamily,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough),
                                                            ),
                                                          ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          );
                        })),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
