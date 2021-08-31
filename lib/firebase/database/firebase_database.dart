import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nineteenfive_admin_panel/models/category.dart';
import 'package:nineteenfive_admin_panel/models/poster.dart';
import 'package:nineteenfive_admin_panel/models/product.dart';
import 'package:nineteenfive_admin_panel/models/promo_code.dart';
import 'package:nineteenfive_admin_panel/models/user_data.dart';
import 'package:nineteenfive_admin_panel/utils/data/static_data.dart';

class FirebaseDatabase {
  static Future<void> storeUserData(UserData userData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.userId)
        .set(userData.toJson());
  }

  static Future<UserData> getUserData(String userId) async {
    late UserData userData;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
            userData = UserData.fromJson(value.data()??{});
    });
    return userData;
  }

  static Future<void> storeProduct(Product? product) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(product!.productId)
        .set(product.toJson());
  }


  static Future<List<Product>> fetchProducts() async {
    List<Product> products = [];
    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        print(element.data());
        products.add(Product.fromJson(element.data()));
      });
    });
    return products;
  }

  static Future<void> storeCategory(Category? category) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(category!.categoryId)
        .set(category.toJson());
    StaticData.categories.add(category);
  }

  static Future<void> storePoster(Poster? poster) async {
    await FirebaseFirestore.instance
        .collection('posters')
        .doc(poster!.posterId)
        .set(poster.toJson());
  }
  static Future<void> storePromoCode(PromoCode? promoCode) async {
    await FirebaseFirestore.instance
        .collection('promocodes')
        .doc(promoCode!.promoCodeId)
        .set(promoCode.toJson());
  }

  static Future<List<Category>> fetchCategories() async {
    List<Category> categories = [];
    FirebaseFirestore.instance
        .collection('categories')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        categories.add(Category.fromJson(element.data()));
      });
    });
    return categories;
  }

  static Future<Product> getProduct(String productId) async {
    late Product product;
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get()
        .then((value) {
      product = Product.fromJson(value.data());
    });
    return product;
  }

}
