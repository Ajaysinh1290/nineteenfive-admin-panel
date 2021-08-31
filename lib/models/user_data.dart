
import 'address.dart';
import 'cart.dart';

class UserData {
  late String userId;
  late String email;
  String? mobileNumber;
  List<dynamic>? addresses = [];
  late String userName;
  late String? userProfilePic;
  List<Cart>? cart = [];
  List<dynamic>? orders = [];
  List<dynamic>? likedProducts = [];
  List<dynamic>? promoCodesUsed = [];

  UserData(
      {required this.userId,
        required this.email,
        this.mobileNumber,
        this.addresses,
        required this.userName,
        this.userProfilePic,
        this.cart,
        this.orders,
        this.likedProducts,
        this.promoCodesUsed});

  UserData.fromJson(Map<String, dynamic> data) {
    this.userId = data['user_id'];
    this.email = data['email'];
    this.mobileNumber = data['mobile_number'];
    List<dynamic> addressesList = data['addresses'];
    addressesList.forEach((address) {
      addresses!.add(Address.fromJson(address));
    });
    this.userName = data['user_name'];
    this.userProfilePic = data['user_profile_pic'];
    List<dynamic> cartList = data['cart'];
    cartList.forEach((cartItem) {
      cart!.add(Cart.fromJson(cartItem));
    });
    this.orders = data['orders'];
    this.likedProducts = data['liked_products'];
    this.promoCodesUsed = data['promo_code_used'];
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> addressesList = [];
    if (addresses != null) {
      addresses!.forEach((address) {
        addressesList.add(address.toJson());
      });
    }

    List<Map<String, dynamic>> cartList = [];

    if (cart != null) {
      cart!.forEach((cartItem) {
        cartList.add(cartItem.toJson());
      });
    }

    return {
      'user_id': this.userId,
      'email': this.email,
      'mobile_number': this.mobileNumber,
      'addresses': addressesList,
      'user_name': this.userName,
      'user_profile_pic': this.userProfilePic,
      'cart': cartList,
      'orders': this.orders,
      'liked_products': this.likedProducts,
      'promo_code_used': this.promoCodesUsed
    };
  }
}
