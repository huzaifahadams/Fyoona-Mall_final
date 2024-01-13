// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyoona/vendors/providers/vendor_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../buyers/error_handling.dart';
import '../../../buyers/utils.dart';
import '../../../global_variables.dart';
import '../../models/product.dart';

class ProductsServcies {
  sellProduct(
      {required BuildContext context,
      required String productName,
      required String productDescription,
      required double productPrice,
      required int quantity,
      required String category,
      required List<String> imageUrList, // Change the type to List<String>

      required String brandName,
       DateTime? scheduleDate,
      required String videoUrl,
      double? shippingFee,
      // List<String>? sizeList,
      List<String>? colorList,
      required String vendorId,
      required chargeShipping,
      required approved}) async {
    final userProvider = Provider.of<VendorProvider>(context, listen: false);
    try {
      Product product = Product(
          productName: productName,
          productDescription: productDescription,
          quantity: quantity,
          imageUrList: imageUrList, // Provide a default value for null case
          videoUrl: videoUrl,
          category: category,
          productPrice: productPrice,
          shippingFee: shippingFee,
          scheduleDate: scheduleDate,
          chargeShipping: chargeShipping,
          brandName: brandName,
          // sizeList: sizeList,
          colorList: colorList,
          vendorId: vendorId,
          approved: approved);
      http.Response res = await http.post(
        Uri.parse('$uri/api/products/add-product'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Added Successfully');
          Navigator.pop(context);
        },
      );
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred while uploading product: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
    }
  }
}

//pub
Future<List<Product>> fetchAllProductsvendor(BuildContext context) async {
  // final userProvider = Provider.of<VendorProvider>(context, listen: false);
  final user = Provider.of<VendorProvider>(context).user;
  List<Product> productList = [];
  try {
    http.Response res = await http.get(
      Uri.parse('$uri/api/products/get-products'),
      headers: {
        'Content-Type': 'application/json; charset-UTF-8',
        'x-auth-token': user.token,
      },
    );

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        final List<dynamic> productsJson = jsonDecode(res.body);

        for (int i = 0; i < productsJson.length; i++) {
          final Product product = Product.fromJson(
            jsonEncode(productsJson[i]),
          );

          // Filter products based on the vendorId
          if (product.vendorId == user.id && product.approved == true) {
            productList.add(product);
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
  return productList;
}

//category products

//un published
Future<List<Product>> fetchAllProductsvendor2(BuildContext context) async {
  // final userProvider = Provider.of<VendorProvider>(context, listen: false);
  final user = Provider.of<VendorProvider>(context).user;
  List<Product> productList = [];
  try {
    http.Response res = await http.get(
      Uri.parse('$uri/api/products/get-products'),
      headers: {
        'Content-Type': 'application/json; charset-UTF-8',
        'x-auth-token': user.token,
      },
    );

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        final List<dynamic> productsJson = jsonDecode(res.body);

        for (int i = 0; i < productsJson.length; i++) {
          final Product product = Product.fromJson(
            jsonEncode(productsJson[i]),
          );

          // Filter products based on the vendorId
          if (product.vendorId == user.id && product.approved == false) {
            productList.add(product);
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
  return productList;
}

Future<List<Product>> fetchAllProductsall(BuildContext context) async {
  final user = Provider.of<VendorProvider>(context).user;
  List<Product> productList = [];
  try {
    http.Response res = await http.get(
      Uri.parse('$uri/api/products/get-products'),
      headers: {
        'Content-Type': 'application/json; charset-UTF-8',
        'x-auth-token': user.token,
      },
    );

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        final List<dynamic> productsJson = jsonDecode(res.body);

        for (int i = 0; i < productsJson.length; i++) {
          final Product product = Product.fromJson(
            jsonEncode(productsJson[i]),
          );

          // Filter products based on the approved
          if (product.approved == true) {
            productList.add(product);
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
  return productList;
}

Future<List<Product>> fetchProductsByCategory(
    BuildContext context, String categoryName) async {
  // final userProvider = Provider.of<VendorProvider>(context, listen: false);
  final user = Provider.of<VendorProvider>(context).user;
  List<Product> productList = [];
  try {
    http.Response res = await http.get(
      Uri.parse('$uri/api/products/get-products'),
      headers: {
        'Content-Type': 'application/json; charset-UTF-8',
        'x-auth-token': user.token,
      },
    );

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        final List<dynamic> productsJson = jsonDecode(res.body);

        for (int i = 0; i < productsJson.length; i++) {
          final Product product = Product.fromJson(
            jsonEncode(productsJson[i]),
          );

          // Filter products based on the vendorId
          if (product.category == categoryName && product.approved == true) {
            productList.add(product);
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
  return productList;
}

//delete product
delteProduct({
  required BuildContext context,
  required Product product,
  required VoidCallback onSuccess,
}) async {
  final userProvider = Provider.of<VendorProvider>(context, listen: false);
  try {
    http.Response res = await http.post(
      Uri.parse('$uri/api/products/del-product'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
      body: jsonEncode({
        'id': product.id,
      }),
    );

    // ignore: use_build_context_synchronously
    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        onSuccess();
      },
    );
  } on SocketException {
    showSnackBar(context, "Please check your internet connection.");
  } on TimeoutException {
    showSnackBar(context, "The request timed out. Please try again later.");
  } catch (e, stackTrace) {
    showSnackBar(context,
        "An error occurred while deleting products: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");

    // "An error occurred while fetching products: ${e.toString()}");
  }
}

// update product
Future<void> updateProduct({
  required BuildContext context,
  required String id,
  required Map<String, dynamic> updatedData,
}) async {
  final userProvider = Provider.of<VendorProvider>(context, listen: false);
  try {
    http.Response res = await http.post(
      Uri.parse('$uri/api/products/update-product'),
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
