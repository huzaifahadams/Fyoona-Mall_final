import 'package:flutter/material.dart';

class CartAttr with ChangeNotifier {
  final String productName;
  final String productId;
  final List imageUrList;
  int quantity;
  int productQnty;
  final double price;
  final String vendorId;
  final String productSize;
  final String productColor;
  String scheduleDate;
  final String buyersId; // Add this line

  CartAttr({
    required this.productName,
    required this.productId,
    required this.imageUrList,
    required this.quantity,
    required this.productQnty,
    required this.price,
    required this.vendorId,
    required this.productSize,
    required this.productColor,
    required this.scheduleDate,
    required this.buyersId, // Add this line
  });

  // Add this method to convert CartAttr to JSON
  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productId': productId,
      'imageUrList': imageUrList,
      'quantity': quantity,
      'productQnty': productQnty,
      'price': price,
      'vendorId': vendorId,
      'productSize': productSize,
      'productColor': productColor,
      'scheduleDate': scheduleDate,
      'buyersId': buyersId,
    };
  }

  void increaseQnty() {
    quantity++;
  }

  void decreaseQnty() {
    quantity--;
  }
}
