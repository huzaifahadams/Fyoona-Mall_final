import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../global_variables.dart';
import '../../../../vendors/models/product.dart';
import '../../../../vendors/views/services/products_services.dart';
import '../../productDetails/screens/product_detail_screen.dart';

class HomeProductWidget extends StatelessWidget {
  final String categoryName;

  const HomeProductWidget({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: fetchProductsByCategory(context, categoryName),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator(
            color: fyoonaMainColor,
          );
        } else {
          return SingleChildScrollView(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final productData = snapshot.data![index];

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
                  autoInitialize: true, // Initialize video player immediately
                );

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductDetailScreen(
                            productData: productData,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.9, // Adjust the width for your needs

                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 17 /
                                9, // Use a 16:9 aspect ratio for a rectangle shape
                            child: Chewie(
                              controller: chewieController,
                            ),
                          ),
                          Text(
                            productData.productName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 4),
                          ),
                          Text(
                            // ignore: prefer_adjacent_string_concatenation
                            '\$' +
                                " " +
                                productData.productPrice.toStringAsFixed(2),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 4,
                                color: fyoonaMainColor),
                          ),
                        ],
                      ),
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
    );
  }
}
