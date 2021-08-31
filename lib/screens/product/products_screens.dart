import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/models/product.dart';
import 'package:nineteenfive_admin_panel/screens/product/product_details_screen.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/utils/data/static_data.dart';
import 'package:nineteenfive_admin_panel/utils/device_info.dart';
import 'package:nineteenfive_admin_panel/widgets/drop_down_button/my_drop_down_button.dart';
import 'package:nineteenfive_admin_panel/widgets/image/image_network.dart';

import 'add_product.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ScrollController scrollController = ScrollController();
  late String selectedCategoryId;
  Product? product;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCategoryId = StaticData.categories.first.categoryId;
  }

  addNewProduct(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AddProduct();
        });
  }

  editProduct(BuildContext context, Product product) {
    showDialog(
        context: context,
        builder: (context) {
          return AddProduct.editProduct(product);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: product != null
          ? ProductDetailsScreen(
              product: product!,
              onBackButtonPressed: () {
                setState(() {
                  product = null;
                });
              },
            )
          : SingleChildScrollView(
              controller: scrollController,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      direction: MediaQuery.of(context).size.width > 420
                          ? Axis.horizontal
                          : Axis.vertical,
                      children: [
                        Text(
                          "Products",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              highlightColor: Colors.transparent,
                              onTap: () {
                                addNewProduct(context);
                              },
                              child: Tooltip(
                                message: MediaQuery.of(context).size.width < 680
                                    ? 'Add Product'
                                    : '',
                                padding: EdgeInsets.all(
                                    DeviceInfo.isMobile(context) ? 10.0 : 0),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(fontSize: 14),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(4)),
                                verticalOffset: 30,
                                waitDuration: Duration(seconds: 2),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(
                                          Constants.buttonBorderRadius)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 20,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      if (MediaQuery.of(context).size.width >
                                          680)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Add Product',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            MyDropDownButton(
                              value: selectedCategoryId,
                              onChanged: (value) {
                                setState(() {
                                  print(value);
                                  selectedCategoryId = value.toString();
                                });
                              },
                              items: List.generate(StaticData.categories.length,
                                  (index) {
                                return DropdownMenuItem(
                                  value:
                                      StaticData.categories[index].categoryId,
                                  child: Text(
                                    StaticData.categories[index].categoryName,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .where('product_category',
                              isEqualTo: selectedCategoryId)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        late List<Product> products;
                        if (snapshot.hasData) {
                          products = [];
                          List data = snapshot.data.docs;
                          data.forEach((productJsonData) {
                            products
                                .add(Product.fromJson(productJsonData.data()));
                          });
                        }
                        return !snapshot.hasData
                            ? Container()
                            : GridView.builder(
                                itemCount: products.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.all(20.0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 20,
                                        crossAxisCount:
                                            MediaQuery.of(context).size.width >
                                                    1600
                                                ? 5
                                                : MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        1300
                                                    ? 4
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .width >
                                                            900
                                                        ? 3
                                                        : 2,
                                        crossAxisSpacing: 20,
                                        childAspectRatio:
                                            DeviceInfo.isMobile(context)
                                                ? 0.7
                                                : 0.8),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        product = products[index];
                                      });
                                      // editProduct(context, products[index]);
                                    },
                                    child: Container(
                                      width: double.infinity,
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
                                                imageUrl: products[index]
                                                    .productImages
                                                    .first,
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
                                                    products[index].productName,
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
                                                        '${Constants.currencySymbol}${products[index].productPrice}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5!
                                                            .copyWith(
                                                                fontFamily: GoogleFonts
                                                                        .openSans()
                                                                    .fontFamily),
                                                      ),
                                                      if (products[index]
                                                              .productMrp !=
                                                          null)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5.0),
                                                          child: Text(
                                                            '${Constants.currencySymbol}${products[index].productMrp}',
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
                                });
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
