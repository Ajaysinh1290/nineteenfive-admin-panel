import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/models/product.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/widgets/cards/size_card.dart';
import 'package:nineteenfive_admin_panel/widgets/image/image_network.dart';

class ProductBasicDetails extends StatefulWidget {
  final Product product;
  final double? width;
  final double? height;

  ProductBasicDetails(
      {Key? key, required this.product, this.width, this.height})
      : super(key: key);

  @override
  State<ProductBasicDetails> createState() => _ProductBasicDetailsState();
}

class _ProductBasicDetailsState extends State<ProductBasicDetails> {
  int selectedImage = 0;
  late ScrollController pageIndicatorController;
  late PageController pageController;
  late ScrollController scrollController;

  double countRating() {
    double rating = 0;
    if (widget.product.productRatings == null ||
        widget.product.productRatings!.isEmpty) {
      return 5;
    } else {
      widget.product.productRatings!.forEach((ratingMapData) {
        rating += ratingMapData.rating;
      });
    }
    return rating / widget.product.productRatings!.length;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageIndicatorController = ScrollController();
    pageController = PageController(initialPage: selectedImage);
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageIndicatorController.dispose();
    pageController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 500,
      height: widget.height,
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(Constants.containerBorderRadius),
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: widget.width ?? 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Hero(
                    tag: widget.product.productId,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (value) {
                        if (value.primaryDelta! > 0) {
                          pageController.previousPage(
                              duration: Duration(milliseconds: 100),
                              curve: Curves.easeIn);
                        } else {
                          pageController.nextPage(
                              duration: Duration(milliseconds: 100),
                              curve: Curves.easeIn);
                        }
                      },
                      child: PageView.builder(
                        itemCount: widget.product.productImages.length,
                        scrollDirection: Axis.horizontal,
                        controller: pageController,
                        onPageChanged: (value) {
                          if ((selectedImage > value || selectedImage >= 6) &&
                              widget.product.productImages.length > 1) {
                            pageIndicatorController.animateTo(
                                (value - 1) * 18.0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeOutExpo);
                          }
                          setState(() {
                            selectedImage = value;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular((20)),
                                child: ImageNetwork(
                                  imageUrl: widget.product.productImages[index],
                                  fit: BoxFit.cover,
                                )),
                          );
                        },
                      ),
                    ),
                  ),
                  if (widget.product.productImages.length > 1)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 12,
                        width: 120,
                        margin: EdgeInsets.only(bottom: 15),
                        child: Center(
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: pageIndicatorController,
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.product.productImages.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  pageController.animateToPage(index,
                                      duration: Duration(seconds: 2),
                                      curve: Curves.easeOutExpo);
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.linear,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: index == selectedImage
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.3)),
                                  width: 12,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: (40)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.productName,
                      style: Theme.of(context).textTheme.bodyText1),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                              Constants.currencySymbol +
                                  widget.product.productPrice.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(
                                      fontFamily:
                                          GoogleFonts.openSans().fontFamily)),
                          SizedBox(
                            width: 10,
                          ),
                          if (widget.product.productMrp != null)
                            Text(
                              Constants.currencySymbol +
                                  widget.product.productMrp.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      fontFamily:
                                          GoogleFonts.openSans().fontFamily,
                                      color: ColorPalette.grey,
                                      decoration: TextDecoration.lineThrough),
                            )
                        ],
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
                          Text(countRating().toString(),
                              style: Theme.of(context).textTheme.headline5)
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Wrap(
                    children: List.generate(widget.product.productSizes!.length,
                        (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizeCard(
                          size: widget.product.productSizes![index],
                          isSelected: false,
                        ),
                      );
                    }),
                  ),
                  if (widget.product.returnTime != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Icon(Icons.history, color: ColorPalette.grey),
                          SizedBox(
                            width: 10,
                          ),
                          Text((widget.product.returnTime! + " Return Policy"),
                              style: Theme.of(context).textTheme.headline6),
                        ],
                      ),
                    ),
                  Text(widget.product.productDescription,
                      style: Theme.of(context).textTheme.headline6),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
