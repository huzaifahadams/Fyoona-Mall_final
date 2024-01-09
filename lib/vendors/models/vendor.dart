import 'dart:convert';

class Vendor {
  final String fullname;
  final String email;
  final String password;
  final String phonenumber;
  final String token;
  final String location;
  final String businessname;
  final String id;
  final String? vendorlogo;
  final bool approved;
  final String type;
  Vendor(
      {required this.fullname,
      required this.id,
      required this.email,
      required this.password,
      required this.phonenumber,
      required this.token,
      required this.businessname,
      this.vendorlogo,
      required this.location, // u
      this.approved = false,
      this.type = 'isVendor'});

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
        id: map['_id'] as String,
        fullname: map['fullname'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
        phonenumber: map['phonenumber'] as String,
        token:
            map['token'] as String, // Use curly brackets to access map values
        location: map['location']
            as String, // Use curly brackets to access map values
        vendorlogo: map['vendorlogo']
            as String, // Use curly brackets to access map values

        businessname: map['businessname'] as String,
        approved: map['approved'] as bool,

        type: map['type'] as String);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'password': password,
      'phonenumber': phonenumber,
      'token': token,
      'businessname': businessname,
      'location': location,
      'vendorlogo':vendorlogo,
      'approved': approved,
      'type': type,
    };
  }

  String toJson() => json.encode(toMap());
  factory Vendor.fromJson(String source) =>
      Vendor.fromMap(json.decode(source) as Map<String, dynamic>);
  Vendor copyWith({
    String? id,
    String? fullname,
    String? password,
    String? email,
    String? location,
    String? businessname,
    String? token,
    String? phonenumber,
    String? vendorlogo,
    bool? approved,
    String? type,
    // List<dynamic>? cart,
  }) {
    return Vendor(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      password: password ?? this.password,
      email: email ?? this.email,
      location: location ?? this.location,
      businessname: businessname ?? this.businessname,
      vendorlogo: vendorlogo ?? this.vendorlogo,
      approved: approved ?? this.approved,
      type: type ?? this.type,
      token: token ?? this.token,
      phonenumber: phonenumber ?? this.phonenumber,
      // cart:
      //cart ?? this.cart,
    );
  }
}
