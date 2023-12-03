class Buyer {
  String fullname;
  String email;
  String password;
  String phonenumber;
  String userImg;

  Buyer({
    required this.fullname,
    required this.email,
    required this.password,
    required this.phonenumber,
    this.userImg = "", // userImg is not required
  });

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      fullname: json['fullname'],
      email: json['email'],
      password: json['password'],
      phonenumber: json['phonenumber'],
      userImg: json['userImg'] ?? "", // handle null for userImg
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'password': password,
      'phonenumber': phonenumber,
      'userImg': userImg,
    };
  }
}
