import 'dart:convert';
// import 'dart:ffi';

class Buyer {
  final String fullname;
  final String email;
  final String password;
  final String phonenumber;
  final String? userImg;
  final String token;
  final String address;
  final String? type;
  final String id;
  final List<dynamic> cart;

  Buyer({
    required this.fullname,
    required this.cart,
    required this.id,
    required this.email,
    required this.password,
    required this.phonenumber,
    required this.userImg, // userImg is not required
    required this.token,
    this.type,
    required this.address,
  });

  factory Buyer.fromMap(Map<String, dynamic> map) {
    return Buyer(
      id: map['_id'] as String,
      fullname: map['fullname'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phonenumber: map['phonenumber'] as String,
      // userImg: map['userImg'] ,
      token: map['token'] as String, // Use curly brackets to access map values
      userImg: map['userImg'] as String,
      address: map['address'] as String,

      type: map['type'] as String,
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'password': password,
      'phonenumber': phonenumber,
      'token': token,
      'type': type,
      'userImg': userImg,
      'address': address,
      'cart': cart,
    };
  }

  String toJson() => json.encode(toMap());
  factory Buyer.fromJson(String source) =>
      Buyer.fromMap(json.decode(source) as Map<String, dynamic>);
  Buyer copyWith({
    String? id,
    String? fullname,
    String? password,
    String? email,
    String? address,
    bool? isBuyer,
    String? token,
    String? phonenumber,
    String? userImg,
    String? type,
    List<dynamic>? cart,
  }) {
    return Buyer(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      password: password ?? this.password,
      email: email ?? this.email,
      address: address ?? this.address,
      type: type ?? type,
      userImg: userImg ?? this.userImg,
      token: token ?? this.token,
      phonenumber: phonenumber ?? this.phonenumber,
      cart: cart ?? this.cart,
    );
  }
}
