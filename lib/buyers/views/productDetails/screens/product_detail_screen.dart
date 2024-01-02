// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyoona/buyers/views/productDetails/services/product_details_services.dart';
import 'package:photo_view/photo_view.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../const/styles.dart';
import '../../../../vendors/models/product.dart';
import '../../../providers/user_provider.dart';
import '../../nav_screens/widgets/starts.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product productData; // Update the type to Product

  const ProductDetailScreen({Key? key, required this.productData})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String formatedDate(date) {
    final outputDateFormate = DateFormat('dd/MM/yyyy');

    final outPutDate = outputDateFormate.format(date);
    return outPutDate;
  }

  int _imageIndex = 0;

  // ignore: unused_field
  String? _selectedSize;
  // ignore: unused_field
  String? _selectedColor;

  final ProductDetailsService productDetailsService = ProductDetailsService();
// rating calc
  double avgRating = 0;
  double myRating = 0;
  @override
  // rating calc
  void initState() {
    super.initState();
    double totalRating = 0;
    for (int i = 0; i < widget.productData.rating!.length; i++) {
      totalRating += widget.productData.rating![i].rating;
      if (widget.productData.rating![i].buyersId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.productData.rating![i].rating;
      }
    }
    if (totalRating != 0) {
      avgRating = totalRating / widget.productData.rating!.length;
    }
  }

  //cart show

  void addToCart() {
    productDetailsService.addToCart(
      context: context,
      product: widget.productData,
    );
  }

  @override
  Widget build(BuildContext context) {
// Use ChangeNotifierProvider.value to access existing instance

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(widget.productData.productName,
            // Stars(rating: avgRating),

            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ratings'
                      // widget.productData.id!,
                      ),
                  Stars(rating: avgRating),
                ],
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: PhotoView(
                    imageProvider: NetworkImage(
                        widget.productData.imageUrList[_imageIndex]),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.productData.imageUrList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _imageIndex = index;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.yellow.shade900),
                                ),
                                height: 60,
                                width: 60,
                                child: Image.network(
                                    widget.productData.imageUrList[index]),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text(
                // ignore: prefer_interpolation_to_compose_strings
                '\$' + widget.productData.productPrice.toStringAsFixed(2),
                style: TextStyle(
                    fontSize: 22,
                    letterSpacing: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow.shade900),
              ),
            ),
            Text(
              widget.productData.productName,
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product Description',
                    style: TextStyle(color: Colors.yellow.shade900),
                  ),
                  Text(
                    'View More',
                    style: TextStyle(color: Colors.yellow.shade900),
                  )
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.productData.productDescription,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 17, letterSpacing: 3),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Delivery on',
                    style: TextStyle(
                        color: Colors.yellow.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Text(
                    formatedDate(
                      widget.productData.scheduleDate,
                    ),
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4),
                  ),
                ],
              ),
            ),
            ExpansionTile(
              title: const Text(
                'Available Colors',
              ),
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productData.colorList!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: _selectedColor ==
                                    widget.productData.colorList![index]
                                ? Colors.yellow
                                : null,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedColor =
                                      widget.productData.colorList![index];
                                });
                              },
                              child: Text(widget.productData.colorList![index]),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Rate Product',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            RatingBar.builder(
              initialRating: myRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                productDetailsService.rateProduct(
                  context: context,
                  product: widget.productData,
                  rating: rating,
                );
              },
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if (_selectedColor == null) {
              //||_selectedSize == null
              // ignore: void_checks
              return ShowSnack(context, 'Please select the the color');
            } else {
              addToCart();
              // ignore: void_checks
              return ShowSnack2(context,
                  'You Added ${widget.productData.productName} To Your Cart');
            }
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.yellow.shade900),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    CupertinoIcons.cart,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                Text(
                  'ADD TO CART',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
