class Cart {
  late String productId;
  late int numberOfItems;
  String? productSize;

  Cart({required this.productId, required this.numberOfItems, this.productSize});

  Cart.fromJson(Map<String, dynamic> data) {
    this.productId = data['product_id'];
    this.numberOfItems = data['number_of_items'];
    this.productSize = data['product_size'];
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': this.productId,
      'number_of_items': this.numberOfItems,
      'product_size': this.productSize
    };
  }
}
