// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyoona/buyers/models/order.dart';
import 'package:fyoona/vendors/providers/vendor_provider.dart';
import 'package:fyoona/vendors/views/auth/vendor_login.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../buyers/error_handling.dart';
import '../../../buyers/utils.dart';
import '../../../global_variables.dart';

class AccountVendorServices {
//pub
  Future<List<Order>> fetchAllOrdersvendor(BuildContext context) async {
    // final userProvider = Provider.of<VendorProvider>(context, listen: false);
    final user = Provider.of<VendorProvider>(context).user;
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/vendor/get-orders'),
        headers: {
          'Content-Type': 'application/json; charset-UTF-8',
          'x-auth-token': user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final List<dynamic> ordersJson = jsonDecode(res.body);

          for (int i = 0; i < ordersJson.length; i++) {
            final Order orders = Order.fromJson(
              jsonEncode(ordersJson[i]),
            );

            // Filter orders based on the vendorId
            // ignore: unrelated_type_equality_checks
            if (orders.products == user.id) { //vendorId
              orderList.add(orders);
            }
          }
        },
      );
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred while fetching products: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
    }
    return orderList;
  }
//logout
  void logoutvendor(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const VendorLoginScreen();
          },
        ),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

// update product
  Future<void> updateorder({
    required BuildContext context,
    required String id,
    required Map<String, dynamic> updatedData,
  }) async {
    final userProvider = Provider.of<VendorProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/vendor/update-orders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode(
            {'id': id, ...updatedData}), // Include the product ID in the body
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred while updating the product: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
    }
  }


  
}
