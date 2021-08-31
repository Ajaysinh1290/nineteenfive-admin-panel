import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/models/order.dart';
import 'package:nineteenfive_admin_panel/models/product.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/widgets/cards/size_card.dart';
import 'package:nineteenfive_admin_panel/widgets/image/image_network.dart';

class OrderBasicDetails extends StatefulWidget {
  final Order order;

  const OrderBasicDetails({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderBasicDetails> createState() => _OrderBasicDetailsState();
}

class _OrderBasicDetailsState extends State<OrderBasicDetails> {
  Product? product;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProduct();
  }

  fetchProduct() async {
    await FirebaseFirestore.instance
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
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(Constants.containerBorderRadius),
      ),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: MediaQuery.of(context).size.width > 420
            ? Axis.horizontal
            : Axis.vertical,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: product != null
                ? ImageNetwork(
                    imageUrl: product!.productImages.first,
                    width: MediaQuery.of(context).size.width > 420
                        ? 188
                        : double.infinity,
                    height: MediaQuery.of(context).size.width > 420
                        ? 210
                        : MediaQuery.of(context).size.width,
                  )
                : Container(
                    alignment: Alignment.center,
                    width: 188,
                    height: 215,
                    child: Icon(
                      Icons.image,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
          ),
          SizedBox(
            width: 15,
            height: 15,
          ),
          Flexible(
            flex:  MediaQuery.of(context).size.width > 420 ?1 :0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product == null ? '' : product!.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        Constants.currencySymbol +
                            widget.order.totalAmount.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(
                                fontFamily:
                                    GoogleFonts.openSans().fontFamily)),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                if (widget.order.productSize != null)
                  Padding(
                    padding: EdgeInsets.only(right: 10, bottom: 10),
                    child: Row(
                      children: [
                        Text('Size  :  ',
                            style: Theme.of(context).textTheme.headline5),
                        SizeCard(
                          isSelected: false,
                          size: widget.order.productSize,
                          margin: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Text('Qty  :  ',
                        style: Theme.of(context).textTheme.headline5),
                    SizeCard(
                      isSelected: false,
                      size: widget.order.numberOfItems.toString(),
                      selectedItemTextColor: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
