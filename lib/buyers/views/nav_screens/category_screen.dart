import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../const/images.dart';
import '../../../global_variables.dart';
import '../../inner_screens/all_products_screen_cart.dart';
import '../../utils.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  late Future<List<Map<String, dynamic>>> _categoriesFuture;

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$uri/api/admin/getcategory'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> categories =
            List<Map<String, dynamic>>.from(data);
        return categories;
      } else {
        // Handle error if needed
        throw Exception('Failed to load categories');
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
          'Categories',
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
            return const Image(image: AssetImage(errorzimg));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: fyoonaMainColor));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Image(image: AssetImage(errorzimg)));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final categoryData = snapshot.data![index];

              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListTile(
                  onTap: () {
                    final categoryName = categoryData['categoryName'];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AllProductScreenCart(
                              categoryData: categoryData,
                              categoryName: categoryName);
                        },
                      ),
                    );
                  },
                  leading: Image.network(categoryData['categoryImg']),
                  title: Text(categoryData['categoryName']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
