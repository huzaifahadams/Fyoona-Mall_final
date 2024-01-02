import 'dart:convert';

import '../../buyers/models/rating.dart';

void showErrorMessage(String message) {
  // show the SnackBar using the message parameter
}

class Product {
  final String productName;
  final String productDescription;
  final int quantity;
  final List<String> imageUrList;
  final String videoUrl;
  final String category;
  final double productPrice;
  final String? id;
  final DateTime? scheduleDate;
  final bool? chargeShipping;
  final double? shippingFee;
  final String? brandName;
  // final List<String>? sizeList;
  final List<String>? colorList;
  final String vendorId;
  final bool? approved;
  final List<Rating>? rating;

  Product({
    required this.productName,
    required this.productDescription,
    required this.quantity,
    required this.imageUrList,
    required this.videoUrl,
    required this.category,
    required this.productPrice,
     this.scheduleDate,
    this.id,
    this.chargeShipping,
    this.shippingFee,
    required this.brandName,
    // this.sizeList,
    this.colorList,
    required this.vendorId,
    required this.approved,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productName': productName,
      'productDescription': productDescription,
      'quantity': quantity,
      'imageUrList': imageUrList,
      'videoUrl': videoUrl,
      'category': category,
      'productPrice': productPrice,
      // 'scheduleDate': scheduleDate,
      // ignore: unnecessary_null_comparison
      'scheduleDate': scheduleDate != null
          ? scheduleDate!.toLocal().toIso8601String().split('T')[0]
          : null,
      'chargeShipping': chargeShipping,
      'shippingFee': shippingFee,
      'brandName': brandName,
      // 'sizeList': sizeList,
      'colorList': colorList,
      'vendorId': vendorId,
      'approved': approved,
      'rating': rating,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'],
      productName: map['productName'] ?? '',
      productDescription: map['productDescription'] ?? '',
      quantity: map['quantity'],
      imageUrList: List<String>.from(map['imageUrList']),
      videoUrl: map['videoUrl'] ?? '',
      category: map['category'] ?? '',
      productPrice: map['productPrice']?.toDouble() ?? 0.0,
      scheduleDate: map['scheduleDate'] != null
          ? DateTime.parse(map['scheduleDate'] as String)
          : null,
      chargeShipping: map['chargeShipping'] as bool?,
      shippingFee: map['shippingFee']?.toDouble(),
      brandName: map['brandName'] ?? '',
      // sizeList: List<String>.from(map['sizeList']),
      colorList: List<String>.from(map['colorList']),
      vendorId: map['vendorId'] ?? '',
      approved: map['approved'] as bool?,
      rating: map['ratings'] != null
          ? List<Rating>.from(
              map['ratings']?.map(
                (x) => Rating.fromMap(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
