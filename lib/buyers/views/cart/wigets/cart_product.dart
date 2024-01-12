import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fyoona/buyers/views/cart/services/cart_services.dart';

import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../vendors/models/product.dart';
import '../../../providers/user_provider.dart';
import '../../productDetails/services/product_details_services.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({super.key, required this.index});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final ProductDetailsService productDetailsService = ProductDetailsService();
  final CartServices cartServices = CartServices();
  void increseQnty(Product productData) {
    productDetailsService.addToCart(
      context: context,
      product: productData,
    );
    setState(() {
      increseQnty;
    });
  }

  void decreseQnty(Product productData) {
    cartServices.removeFromCart(
      context: context,
      product: productData,
    );
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final productData = Product.fromMap(productCart['product']);
    final quantity = productCart['quantity'];
    final selectedColor = productCart['selectedColor'];
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              CachedNetworkImage(
                height: 135,
                width: 135,
                imageUrl: productData.imageUrList[0],
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer(
                  duration: const Duration(seconds: 10),
                  interval: const Duration(seconds: 10),
                  color: Colors.white,
                  colorOpacity: 0,
                  enabled: true,
                  direction: const ShimmerDirection.fromLTRB(),
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Column(
                children: [
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      productData.productName,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      '\$${productData.productPrice}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10),
                    child: (productData.shippingFee == null)
                        ? const Text("Eligible for Free Shipping")
                        : Text('Shipping fee \$${productData.shippingFee}'),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: (selectedColor == null)
                        ? const Text("")
                        : Text(
                            selectedColor.toString(),
                            style: const TextStyle(
                              color: Colors.teal,
                            ),
                            maxLines: 2,
                          ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Text(
                      '${productData.quantity} in stock',
                      style: const TextStyle(
                        color: Colors.teal,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5),
                color: Colors.black12,
              ),
              child: Row(children: [
                InkWell(
                  onTap: () => decreseQnty(productData),
                  child: Container(
                    width: 35,
                    height: 32,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.remove,
                      size: 18,
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: 1.5,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Container(
                    width: 35,
                    height: 32,
                    alignment: Alignment.center,
                    child: Text(
                      quantity.toString(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => increseQnty(productData),
                  child: Container(
                    width: 35,
                    height: 32,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.add,
                      size: 18,
                    ),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ],
    );
  }
}
