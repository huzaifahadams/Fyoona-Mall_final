import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyoona/buyers/views/productDetails/store_product_details.dart';
import 'package:http/http.dart' as http;

import '../../../global_variables.dart';
import '../../utils.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  StoreScreenState createState() => StoreScreenState();
}

class StoreScreenState extends State<StoreScreen> {
  late Future<List<Map<String, dynamic>>> _categoriesFuture;

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response =
          await http.get(Uri.parse('$uri/api/vendor/get-approved-vendors'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> stores =
            List<Map<String, dynamic>>.from(data);
        return stores;
      } else {
        // Handle error if needed
        throw Exception('Failed to load Stores');
      }
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred while uploading product: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
    }
    return []; // You can return an empty list or another appropriate default value
  }

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Text(
            'stores',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
            future: _categoriesFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                        color: fyoonaMainColor));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Stores available'));
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final storeData = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return StoreProductsScreen(
                          storeData: storeData,
                        );
                      }));
                    },
                    child: ListTile(
                      title: Text(storeData['businessname']!),
                      subtitle: Text(storeData['location']!),
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(storeData['vendorlogo']!)),
                    ),
                  );
                },
              );
            }));
  }
}
