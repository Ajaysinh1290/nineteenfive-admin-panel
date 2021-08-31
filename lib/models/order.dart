import 'package:nineteenfive_admin_panel/utils/data/static_data.dart';

import 'address.dart';

class Order {
  late String orderId;
  DateTime? orderTime;
  late int totalAmount;
  late String productId;
  late int numberOfItems;
  String? productSize;
  Address? address;
  late String userId;
  String? transactionId;
  DateTime? shippingTime;
  DateTime? outForDeliveryTime;
  DateTime? deliveryTime;
  ProductCancel? productCancel;
  ProductReturn? productReturn;
  String? returnTime;
  int? shippingCharge;
  int? promoCodeDiscount;
  String? promoCode;

  Order(
      {required this.orderId,
        this.orderTime,
        required this.totalAmount,
        required this.productId,
        required this.numberOfItems,
        this.productSize,
        this.address,
        required this.userId,
        this.transactionId,
        this.shippingTime,
        this.productReturn,
        this.outForDeliveryTime,
        this.productCancel,
        this.deliveryTime,
        this.promoCodeDiscount,
        this.returnTime,
        this.promoCode,
        this.shippingCharge});

  Order.fromJson(Map<String, dynamic>? data) {
    this.orderId = data!['order_id'];
    this.orderTime = data['order_time'].toDate();
    this.totalAmount = data['total_amount'];
    this.productId = data['product_id'];
    this.numberOfItems = data['number_of_items'];
    this.productSize = data['product_size'];
    this.address =
    data['address'] == null ? null : Address.fromJson(data['address']);
    this.userId = data['user_id'];
    this.transactionId = data['transaction_id'];
    this.outForDeliveryTime = data['out_for_delivery_time']?.toDate();
    this.shippingTime = data['shipping_time']?.toDate();
    this.deliveryTime = data['delivery_time']?.toDate();
    this.productCancel = data['product_cancel'] == null
        ? null
        : ProductCancel.fromJson(data['product_cancel']);
    this.productReturn = data['product_return'] == null
        ? null
        : ProductReturn.fromJson(data['product_return']);
    this.returnTime = data['return_time'];
    this.shippingCharge = data['shipping_charge']??40;
    this.promoCodeDiscount = data['promo_code_discount'];
    this.promoCode = data['promo_code'];
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': this.orderId,
      'order_time': this.orderTime,
      'total_amount': this.totalAmount,
      'product_id': this.productId,
      'number_of_items': this.numberOfItems,
      'product_size': this.productSize,
      'address': this.address!.toJson(),
      'user_id': this.userId,
      'transaction_id': this.transactionId,
      'shipping_time': this.shippingTime,
      'out_for_delivery_time': this.outForDeliveryTime,
      'delivery_time': this.shippingTime,
      'product_cancel': this.productCancel?.toJson(),
      'product_return': this.productReturn?.toJson(),
      'return_time': this.returnTime,
      "shipping_charge": this.shippingCharge,
      "promo_code_discount": this.promoCodeDiscount,
      'promo_code': this.promoCode
    };
  }
}

class ProductReturn {
  DateTime? returnRequestTime;
  String? returnReason;
  DateTime? productPickupTime;
  DateTime? productReceivedTime;
  DateTime? refundTime;
  BankDetails? bankDetails;
  Address? pickUpAddress;
  int? numberOfItems;

  ProductReturn(
      {this.returnRequestTime,
        this.returnReason,
        this.productPickupTime,
        this.productReceivedTime,
        this.refundTime,
        this.bankDetails,
        this.pickUpAddress,
        this.numberOfItems});

  ProductReturn.fromJson(Map<String, dynamic> data) {
    this.returnRequestTime = data['return_request_time'].toDate();
    this.returnReason = data['return_reason'];
    this.productPickupTime = data['product_pickup_time']?.toDate();
    this.refundTime = data['refund_time']?.toDate();
    this.productReceivedTime = data['product_received_time']?.toDate();
    this.bankDetails = data['bank_details'] == null
        ? null
        : BankDetails.fromJson(data['bank_details']);
    this.pickUpAddress = data['pick_up_address'] == null
        ? null
        : Address.fromJson(data["pick_up_address"]);
    this.numberOfItems = data['number_of_items'];
  }

  Map<String, dynamic> toJson() {
    return {
      'return_request_time': this.returnRequestTime,
      'return_reason': this.returnReason,
      'product_pickup_time': this.productPickupTime,
      'refund_time': this.refundTime,
      'product_received_time': this.productReceivedTime,
      'bank_details': this.bankDetails!.toJson(),
      'pick_up_address': this.pickUpAddress!.toJson(),
      'number_of_items': this.numberOfItems
    };
  }
}

class ProductCancel {
  DateTime? refundTime;
  DateTime? cancellationTime;
  String? cancelReason;
  BankDetails? bankDetails;

  ProductCancel(
      {this.refundTime,
        this.cancellationTime,
        this.cancelReason,
        this.bankDetails});

  ProductCancel.fromJson(Map<String, dynamic> data) {
    this.refundTime = data['refund_time'];
    this.cancelReason = data['cancel_reason'];
    this.cancellationTime = data['cancellation_time'].toDate();
    this.bankDetails = data['bank_details'] == null
        ? null
        : BankDetails.fromJson(data['bank_details']);
  }

  Map<String, dynamic> toJson() {
    return {
      'refund_time': this.refundTime,
      'cancellation_time': this.cancellationTime,
      'cancel_reason': this.cancelReason,
      'bank_details': this.bankDetails!.toJson()
    };
  }
}

class BankDetails {
  late String accountNumber;
  late String ifscCode;
  late String accountHolderName;

  BankDetails(
      {required this.accountNumber,
        required this.ifscCode,
        required this.accountHolderName});

  BankDetails.fromJson(Map<String, dynamic> data) {
    accountNumber = data['account_number'];
    ifscCode = data['ifsc_code'];
    accountHolderName = data['account_holder_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': this.accountNumber,
      'ifsc_code': this.ifscCode,
      'account_holder_name': this.accountHolderName
    };
  }
}
