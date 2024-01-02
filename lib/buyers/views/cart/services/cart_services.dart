import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyoona/buyers/models/user.dart';

// import 'package:fyoona_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../../global_variables.dart';
import '../../../../vendors/models/product.dart';
import '../../../error_handling.dart';
import '../../../providers/user_provider.dart';
import '../../../utils.dart';

class CartServices {
  //add to cart
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/users/remove-from-cart/${product.id}'),
        headers: {
          // <String, String>
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Buyer user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);

          userProvider.setUserFromModel(user);
        },
      );
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred : ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");

      // "An error occurred while fetching products: ${e.toString()}");
    }
  }


}
