import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyoona/buyers/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../../../../global_variables.dart';
import '../../../../../error_handling.dart';
import '../../../../../providers/user_provider.dart';
import '../../../../../utils.dart';
import '../../../../main_screen.dart';

class AddressServcies {
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/users/save-user-address'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'address': address}),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Buyer user = userProvider.user.copyWith(
            address: jsonDecode(res.body)['address'],
          );
          userProvider.setUserFromModel(user);
        },
      );
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred while saving address : ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");

      // "An error occurred while fetching products: ${e.toString()}");
    }
  }

  // get orders

  void placeOrder(
    //required
    BuildContext context,
    String address,
    // String selectColor,
    double totalSum,
    // String fullname,
    // String phone,
    // String email,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(Uri.parse('$uri/api/users/order'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            'cart': userProvider.user.cart,
            'address': address,
            'fullname': userProvider.user.fullname,
            'phone': userProvider.user.phonenumber,
            'email': userProvider.user.email,
            'totalPrice': totalSum,
          }));
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'your order has been placed!');
            Buyer user = userProvider.user.copyWith(
              cart: [],
            );
            userProvider.setUserFromModel(user);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const MainScreen();
                },
              ),
            );
          });
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred while buying products: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");

      // "An error occurred while fetching products: ${e.toString()}");
    }
  }
}
