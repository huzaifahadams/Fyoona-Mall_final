import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyoona/buyers/models/order.dart';
import 'package:fyoona/buyers/providers/user_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../../global_variables.dart';
import '../../../../vendors/models/product.dart';
import '../../../error_handling.dart';
import '../../../utils.dart';

class Orders extends StatelessWidget {
  const Orders({
    super.key,
  });

  String formatedDate(date) {
    final outputDateFormate = DateFormat('dd/MM/yyyy');

    final outPutDate = outputDateFormate.format(date);
    return outPutDate;
  }

  Future<List<Order>> fetchAllOrdersvendor(BuildContext context) async {
    final user = Provider.of<UserProvider>(context).user;
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/users/get-orders'),
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

            // ignore: unrelated_type_equality_checks
            if (orders.buyersId == user.id) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            true, // Set this to false to hide the back button

        elevation: 0,
        backgroundColor: fyoonaMainColor,
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
      body: FutureBuilder<List<Order>>(
        future: fetchAllOrdersvendor(context),
        builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<Order>? orderList = snapshot.data;

          return ListView.builder(
            itemCount: orderList!.length,

            // itemBuilder: (BuildContext context, int index) {
            itemBuilder: (context, index) {
              final Order buyerOrderData = orderList[index];

              return SingleChildScrollView(
                  child: Slidable(
                      key: ValueKey(index),
                      child: Column(children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 14,
                            child: buyerOrderData.status == 'delivered'
                                ? const Icon(Icons.delivery_dining)
                                : const Icon(Icons.access_time),
                          ),
                          title: buyerOrderData.status == 'delivered'
                              ? Text(
                                  'delivered',
                                  style:
                                      TextStyle(color: fyoonaMainColor),
                                )
                              : const Text(
                                  'Not delivered',
                                  style: TextStyle(color: Colors.red),
                                ),
                          trailing: Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            'Amount ' +
                                buyerOrderData.products[0].productPrice
                                    .toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 17, color: Colors.blue),
                          ),
                          subtitle: Text(
                            formatedDate(buyerOrderData.orderDate),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                        ExpansionTile(
                          title: Text(
                            'Order Details',
                            style: TextStyle(
                                color: fyoonaMainColor, fontSize: 15),
                          ),
                          subtitle: const Text('View Order Details'),
                          children:
                              buyerOrderData.products.map((Product product) {
                            int quantityForProduct = buyerOrderData.quantity[
                                buyerOrderData.products.indexOf(product)];

                            return ListTile(
                              leading: CircleAvatar(
                                child: Image.network(product.imageUrList[0]),
                              ),
                              title: Text(product.productName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text(
                                        ('Quantity'),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        quantityForProduct.toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  buyerOrderData.status == 'delivered'
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text(
                                              ('Schedule Delivery Date'),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              formatedDate(
                                                  product.scheduleDate),
                                              // .toDate()
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      : const Text(''),
                                  ListTile(
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      ])));
            },
          );
        },
      ),
    );
  }
}
