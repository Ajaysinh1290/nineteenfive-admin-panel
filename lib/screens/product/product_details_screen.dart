import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/models/product.dart';
import 'package:nineteenfive_admin_panel/screens/product/product_basic_details.dart';
import 'package:nineteenfive_admin_panel/screens/product/product_more_details.dart';
import 'package:nineteenfive_admin_panel/screens/product/product_orders_table.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

import 'add_product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  final Function() onBackButtonPressed;

  ProductDetailsScreen(
      {required this.product, required this.onBackButtonPressed});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      'Products',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                InkWell(
                  onTap: (){
                    showDialog(context: context,builder: (context)=>AddProduct.editProduct(widget.product));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
                      color: Theme.of(context).primaryColor
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Edit Product',
                          style: Theme.of(context).textTheme.headline5,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double height = constraints.maxWidth > 1200 ? 820 : 1100;
                return constraints.maxWidth > 840
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductBasicDetails(
                            product: widget.product,
                            height: height - 20,
                          ),
                          Expanded(
                              child: ProductMoreDetails(
                            product: widget.product,
                            height: height,
                          )),
                        ],
                      )
                    : Column(
                        children: [
                          ProductBasicDetails(
                            product: widget.product,
                            width: constraints.maxWidth,
                          ),
                          ProductMoreDetails(
                            product: widget.product,
                            height: height,
                          ),
                        ],
                      );
              },
            ),
            SizedBox(
              height: 20,
            ),
            ProductOrdersTable(
              product: widget.product,
            )
          ],
        ),
      ),
    );
  }
}
