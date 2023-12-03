import 'package:flutter/material.dart';

import '../models/user.dart';
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  Buyer _user = Buyer(
    email: '',
    fullname: '',
    password: '',
    phonenumber: '',
  );

  Buyer get user => _user;
  void setUser(String user) {
    Map<String, dynamic> userData = jsonDecode(user);
    _user = Buyer.fromJson(userData);
    notifyListeners();
  }
// ///updaing
//   void updateProductQuantity(int index, int quantity) {
//     _user.cart[index]['quantity'] = quantity;
//     notifyListeners();
//   }

  void setUserFromModel(Buyer user) {
    _user = user;
    notifyListeners();
  }
}
