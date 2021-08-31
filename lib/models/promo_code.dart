class PromoCode {
  late String promoCodeId;
  late String promoCode;
  late int discount;
  late DateTime activeOn;
  late DateTime expireOn;

  PromoCode(
      {required this.promoCode,
      required this.discount,
      required this.promoCodeId,
      required this.activeOn,
      required this.expireOn});

  PromoCode.fromJson(Map<String, dynamic> data) {
    this.promoCodeId = data['promo_code_id'];
    this.promoCode = data['promo_code'];
    this.discount = data['discount'];
    this.activeOn = data['active_on']?.toDate();
    this.expireOn = data['expire_on']?.toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      'promo_code': this.promoCode,
      'discount': this.discount,
      'active_on': this.activeOn,
      'expire_on': this.expireOn,
      'promo_code_id': this.promoCodeId
    };
  }
}
