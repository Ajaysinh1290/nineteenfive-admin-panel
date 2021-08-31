import 'package:nineteenfive_admin_panel/models/product_rating.dart';

class Product {
  late String productId;
  late String productName;
  late String productCategory;
  late int productPrice;
  int? productMrp;
  late DateTime productCreatedOn;
  late int availableStock;
  List<dynamic>? productSizes = [];
  late List<dynamic> productImages = [];
  List<ProductRating>? productRatings = [];
  late String productDescription;
  late bool isActive;
  late bool isFeatured;
  String? returnTime;
  int? shippingCharge;

  Product(
      {required this.productId,
        required this.productName,
        required this.productCreatedOn,
        required this.productCategory,
        required this.productPrice,
        this.productMrp,
        this.productSizes,
        required this.availableStock,
        required this.productImages,
        this.productRatings,
        required this.productDescription,
        this.returnTime,
        required this.isActive,
        this.shippingCharge,
        required this.isFeatured});

  Product.fromJson(Map<String, dynamic>? data) {
    this.productId = data!['product_id'];
    this.productName = data['product_name'];
    this.availableStock = data['available_stock'];
    this.productCreatedOn = data['product_created_on'].toDate();
    this.productCategory = data['product_category'];
    this.productPrice = data['product_price'];
    this.productMrp = data['product_mrp'];
    this.productDescription = data['product_description'];
    this.productSizes = data['product_sizes'];
    this.productImages = data['product_images'];
    this.isActive = data['is_active']??true;
    this.isFeatured = data['is_featured']??true;
    List<dynamic> productRatingsList = data['product_ratings'] ?? [];
    productRatingsList.forEach((rating) {
      productRatings!.add(ProductRating.fromJson(rating));
    });

    this.returnTime = data['return_time'];
    this.shippingCharge = data['shipping_charge'];
  }

  Map<String, dynamic> toJson() {
    List<dynamic> productRatingsList = [];
    productRatings!.forEach((rating) {
      productRatingsList.add(rating.toJson());
    });
    return {
      'product_id': this.productId,
      'product_name': this.productName,
      'product_created_on': this.productCreatedOn,
      'product_category': this.productCategory,
      'product_price': this.productPrice,
      'product_mrp': this.productMrp,
      'product_description': this.productDescription,
      'product_sizes': this.productSizes,
      'product_ratings': productRatingsList,
      'product_images': this.productImages,
      'available_stock': this.availableStock,
      'return_time': this.returnTime,
      'is_active': this.isActive,
      'is_featured': this.isFeatured,
      'shipping_charge' : this.shippingCharge
    };
  }
}
