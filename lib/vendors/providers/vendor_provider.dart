import 'package:flutter/material.dart';

import '../models/vendor.dart';

class VendorProvider extends ChangeNotifier {
  Vendor _user = Vendor(
      email: '',
      fullname: '',
      password: '',
      phonenumber: '',
      token: '',
      id: '',
      vendorlogo: '',
      location: '',
      approved: false,
      type: 'isVendor',
      businessname: '');
  Vendor get user => _user;
  void setUser(String user) {
    _user = Vendor.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(Vendor user) {
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
