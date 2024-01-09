import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:fyoona/buyers/views/productDetails/screens/product_detail_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import '../../../global_variables.dart';
import '../../../vendors/models/product.dart';
import '../../utils.dart';

class StoreProductsScreen extends StatefulWidget {
  final dynamic storeData;

  const StoreProductsScreen({super.key, required this.storeData});

  @override
  State<StoreProductsScreen> createState() => _StoreProductsScreenState();
}

class _StoreProductsScreenState extends State<StoreProductsScreen> {
  // late Future<List<Map<String, dynamic>>> _storeFuture;
  Future<List<Product>> fetchStored(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/products/get-products'),
      );
      // Replace 'vendorId' with the actual field name in your API response
      final String vendorId = widget.storeData['_id'];

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> vendors =
            List<Map<String, dynamic>>.from(data);

        // Filter products based on the 'vendorId'
        final List<Map<String, dynamic>> productsData = vendors
            .where((vendors) => vendors['vendorId'] == vendorId)
            .toList();

        final List<Product> products = productsData
            .map((productData) => Product.fromMap(productData))
            .toList();

        return products;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fyoonaMainColor,
        title: Text(
          widget.storeData['businessname'],
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchStored(context),

        // FutureBuilder<List<Map<String, dynamic>>>(
        //   future: _storeFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator(
              color: fyoonaMainColor,
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No  Products',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return SingleChildScrollView(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final productData = snapshot.data![index];

                  // ignore: deprecated_member_use
                  final videoPlayerController = VideoPlayerController.network(
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ProductDetailScreen(
                          productData: productData,
                        );
                      }));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            // ignore: prefer_interpolation_to_compose_strings
                            '\$'
                                    " " +
                                (productData.productPrice).toStringAsFixed(2),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 4,
                              color: fyoonaMainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, _) => const SizedBox(width: 15),
                itemCount: snapshot.data!.length,
              ),
            );
          }
        },
      ),
    );
  }
}
