import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyoona/buyers/error_handling.dart';
import 'package:fyoona/buyers/providers/user_provider.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../../global_variables.dart';
import '../../../../vendors/models/product.dart';
import '../../../models/user.dart';
import '../../../utils.dart';

class ProductDetailsService {
  //add to cart
  void addToCart({
    required BuildContext context,
    required Product product,
    String? selectedColor,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/users/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,

        },
        body: jsonEncode({
          'id': product.id!,
          'selectedColor':selectedColor,
          
          }),
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
    }
  }

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/products/rate-product'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': product.id!, 'rating': rating}),
      );

      // ignore: use_build_context_synchronously
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
          "An error occurred : ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");

      // "An error occurred while fetching products: ${e.toString()}");
    }
  }

//   // get products

//   Future<List<Product>> fetchAllProducts(BuildContext context) async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     List<Product> productList = [];
//     try {
//       http.Response res =
//           await http.get(Uri.parse('$uri/admin/get-products'), headers: {
//         'Content-Type': 'application/json; charset-UTF-8',
//         'x-auth-token': userProvider.user.token,
//       });
//       // ignore: use_build_context_synchronously
//       httpErrorHandle(
//         response: res,
//         context: context,
//         onSuccess: () {
//           for (int i = 0; i < jsonDecode(res.body).length; i++) {
//             productList.add(
//               Product.fromJson(
//                 jsonEncode(jsonDecode(res.body)[i]),
//               ),
//             );
//           }
//         },
//       );
//     } on SocketException {
//       showSnackBar(context, "Please check your internet connection.");
//     } on TimeoutException {
//       showSnackBar(context, "The request timed out. Please try again later.");
//     } catch (e, stackTrace) {
//       showSnackBar(context,
//           "An error occurred while fetching products: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");

//       // "An error occurred while fetching products: ${e.toString()}");
//     }
//     return productList;
//   }

//   //delete product
//   void delteProduct({
//     required BuildContext context,
//     required Product product,
//     required VoidCallback onSuccess,
//   }) async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     try {
//       http.Response res = await http.post(
//         Uri.parse('$uri/admin/del-product'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'x-auth-token': userProvider.user.token,
//         },
//         body: jsonEncode({
//           'id': product.id,
//         }),
//       );

//       // ignore: use_build_context_synchronously
//       httpErrorHandle(
//         response: res,
//         context: context,
//         onSuccess: () {
//           onSuccess();
//         },
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//   }
// }
}
