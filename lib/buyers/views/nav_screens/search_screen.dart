import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import '../../../global_variables.dart';
import '../../../vendors/models/product.dart';
import '../../utils.dart';
import '../productDetails/screens/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  String _searchedValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade800,
        elevation: 0,
        title: TextFormField(
          onChanged: (value) {
            setState(() {
              _searchedValue = value;
            });
          },
          decoration: const InputDecoration(
            labelText: 'Search For Products',
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: _searchedValue == ''
          ? const Center(
              child: Text(
                'Search For Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            )
          : FutureBuilder<List<Product>>(
              future: fetchSearchedProducts(context),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LinearProgressIndicator(
                    color: Colors.yellow.shade900,
                  );
                } else {
                  final searchedData = snapshot.data!.where((element) {
                    return element.productName
                        .toLowerCase()
                        .contains(_searchedValue.toLowerCase());
                  });

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final productData = searchedData.elementAt(index);

                              final videoPlayerController =
                                  // ignore: deprecated_member_use
                                  VideoPlayerController.network(
                                productData.videoUrl,
                              );

                              final chewieController = ChewieController(
                                videoPlayerController: videoPlayerController,
                                autoPlay: false,
                                looping: false,
                                materialProgressColors: ChewieProgressColors(
                                  playedColor: Colors.red,
                                  handleColor: Colors.redAccent,
                                  backgroundColor: Colors.transparent,
                                  bufferedColor: Colors.lightGreen,
                                ),
                                autoInitialize: true,
                              );

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ProductDetailScreen(
                                        productData: productData,
                                      );
                                    }),
                                  );
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 17 / 9,
                                        child: Chewie(
                                          controller: chewieController,
                                        ),
                                      ),
                                      Text(
                                        productData.productName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          letterSpacing: 4,
                                        ),
                                      ),
                                      Text(
                                        // ignore: prefer_adjacent_string_concatenation
                                        '\$' +
                                            " " +
                                            (productData.productPrice
                                                .toStringAsFixed(2)),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          letterSpacing: 4,
                                          color: Colors.yellow.shade900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, _) =>
                                const SizedBox(width: 15),
                            itemCount: searchedData.length,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
    );
  }

  Future<List<Product>> fetchSearchedProducts(BuildContext context) async {
    // Future<List<Map<String, dynamic>>> fetchSearchedProducts(
    // BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/products/search?query=$_searchedValue'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Product> products =
            data.map((productData) => Product.fromMap(productData)).toList();

        return products;
      } else {
        throw Exception('Failed to load products');
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
}
