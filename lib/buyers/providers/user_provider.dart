import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  Buyer _user = Buyer(
      email: '',
      fullname: '',
      password: '',
      phonenumber: '',
      address: '',
      token: '',
      userImg: '',
      id: '',
      type: 'isBuyer',
      cart: []);
  Buyer get user => _user;
  void setUser(String user) {
    _user = Buyer.fromJson(user);
    notifyListeners();
  }

  ///updaing
  void updateProductQuantity(int index, int quantity) {
    _user.cart[index]['quantity'] = quantity;
    notifyListeners();
  }

  void setUserFromModel(Buyer user) {
    _user = user;
    notifyListeners();
  }

  String _userToken = '';

  // Getter for user token
  String get userToken => _userToken;

  // Setter for user token
  void setUserToken(String token) {
    _userToken = token;
    notifyListeners();
  }

  // Method to clear user token
  void clearUserToken() {
    _userToken = '';
    notifyListeners();
  }
}
