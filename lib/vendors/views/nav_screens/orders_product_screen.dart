import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyoona/buyers/models/order.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../buyers/error_handling.dart';
import '../../../buyers/utils.dart';
import '../../../global_variables.dart';
import '../../models/product.dart';
import '../../providers/vendor_provider.dart';

class VendorOrdersScreen extends StatelessWidget {
  const VendorOrdersScreen({
    super.key,
  });

  String formatedDate(date) {
    final outputDateFormate = DateFormat('dd/MM/yyyy');

    final outPutDate = outputDateFormate.format(date);
    return outPutDate;
  }

// update product
  Future<void> updateOrders({
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
            {'id': id, ...updatedData}), // Include the order ID in the body
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

  Future<List<Order>> fetchAllOrdersvendor(BuildContext context) async {
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
            if (orders.products[0].vendorId == user.id) {
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
            false, // Set this to false to hide the back button

        elevation: 0,
        backgroundColor: Colors.yellow.shade900,
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
              final Order vendorOrderData = orderList[index];

              return SingleChildScrollView(
                  child: Slidable(
                      key: ValueKey(index),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        key: const ValueKey(0),

                        // A pane can dismiss the Slidable.
                        dismissible: DismissiblePane(onDismissed: () {}),

                        // All actions are defined in the children parameter.
                        children: [
                          // A SlidableAction can have an icon and/or a label.
                          SlidableAction(
                            onPressed: (context) async {
                              await updateOrders(
                                context: context,
                                id: vendorOrderData.id.toString(),
                                updatedData: {'accepted': false},
                              );
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Reject',
                          ),
                          SlidableAction(
                            onPressed: (context) async {
                              await updateOrders(
                                context: context,
                                id: vendorOrderData.id.toString(),
                                updatedData: {'accepted': true},
                              );
                            },
                            backgroundColor: const Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.all_inbox,
                            label: 'Accept',
                          ),
                        ],
                      ), // Add this line to provide a key

                      child: Column(children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 14,
                            child: vendorOrderData.accepted == true
                                ? const Icon(Icons.delivery_dining)
                                : const Icon(Icons.access_time),
                          ),
                          title: vendorOrderData.accepted == true
                              ? Text(
                                  'Accepted',
                                  style:
                                      TextStyle(color: Colors.yellow.shade900),
                                )
                              : const Text(
                                  'Not Accepted',
                                  style: TextStyle(color: Colors.red),
                                ),
                          trailing: Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            'Amount ' +
                                vendorOrderData.products[0].productPrice
                                    .toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 17, color: Colors.blue),
                          ),
                          subtitle: Text(
                            formatedDate(vendorOrderData.orderDate),
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
                                color: Colors.yellow.shade900, fontSize: 15),
                          ),
                          subtitle: const Text('View Order Details'),
                          children:
                              vendorOrderData.products.map((Product product) {
                            int quantityForProduct = vendorOrderData.quantity[
                                vendorOrderData.products.indexOf(product)];

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
                                  vendorOrderData.accepted == true
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
                                    title: const Text(
                                      'Buyer\'s Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(vendorOrderData.fullname),
                                        Text(vendorOrderData.email),
                                        Text(vendorOrderData.phone),
                                        Text(vendorOrderData.address),
                                      ],
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
