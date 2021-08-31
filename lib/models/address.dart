class Address {
  late  String addressId;
  late String name;
  late String mobileNumber;
  late String houseNoOrFlatNoOrFloor;
  late String societyOrStreetName;
  late String landMark;
  late String area;
  late String city;
  late String state;
  late String pinCode;

  Address(
      {required this.addressId,
      required this.name,
      required this.houseNoOrFlatNoOrFloor,
      required this.societyOrStreetName,
      required this.landMark,
      required this.area,
      required this.city,
      required this.state,
      required this.mobileNumber,
      required this.pinCode,
      });

  Address.fromJson(Map<String, dynamic> data) {
    this.addressId = data['address_id'];
    this.name = data['name'];
    this.mobileNumber = data['mobile_number'];
    this.houseNoOrFlatNoOrFloor = data['house_no_or_flat_no_or_floor'];
    this.societyOrStreetName = data['society_or_street_name'];
    this.landMark = data['landmark'];
    this.area = data['area'];
    this.city = data['city'];
    this.state = data['state'];
    this.pinCode = data['pin_code'];
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': this.addressId,
      'name': this.name,
      'house_no_or_flat_no_or_floor': this.houseNoOrFlatNoOrFloor,
      'society_or_street_name': this.societyOrStreetName,
      'landmark': this.landMark,
      'area': this.area,
      'city': this.city,
      'state': this.state,
      'pin_code': this.pinCode,
      'mobile_number': this.mobileNumber
    };
  }
}
