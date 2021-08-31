class Category {
  late String categoryId;
  late String categoryName;
  List<dynamic>? sizes = [];
  late String imageUrl;

  Category(
      {required this.categoryId,
      required this.categoryName,
      this.sizes,
      required this.imageUrl});

  Category.fromJson(Map<String, dynamic> data) {
    this.categoryId = data['category_id'];
    this.categoryName = data['category_name'];
    this.imageUrl = data['image_url'];
    this.sizes = data['sizes'];
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': this.categoryId,
      'category_name': this.categoryName,
      'image_url': this.imageUrl,
      'sizes': this.sizes
    };
  }
}
