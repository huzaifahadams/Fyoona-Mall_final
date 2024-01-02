// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import '../../vendors/models/product.dart';

class Order {
  final String id;
  final List<Product> products;
  final List<int> quantity;
  final String address;
  final String buyersId;
  final int orderedAt;
  final String status;
  final bool accepted;
  final String fullname;
  final String email;
  final String phone;
  final DateTime orderDate; //datetime
  final double totalPrice;
  Order({
    required this.id,
    required this.products,
    required this.quantity,
    required this.address,
    required this.buyersId,
    required this.orderedAt,
    required this.status,
    required this.accepted,
    required this.totalPrice,
    required this.fullname,
    required this.email,
    required this.phone,
    required this.orderDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'quantity': quantity,
      'address': address,
      'buyersId': buyersId,
      'orderedAt': orderedAt,
      'status': status,
      'accepted': accepted,
      'totalPrice': totalPrice,
      'fullname': fullname,
      'email': email,
      'phone': phone,
      'orderDate': DateTime.now(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? '',
      products: List<Product>.from(
          map['products']?.map((x) => Product.fromMap(x['product']))),
      quantity: List<int>.from(
        (map['products']?.map((x) => x['quantity'])),
      ),
      address: map['address'] ?? '',
      buyersId: map['buyersId'] ?? '',
      orderedAt: map['orderedAt']?.toInt() ?? 0,
      status: map['status'] ?? '',
      accepted: map['accepted'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      fullname: map['fullname'] ?? '',
      // orderDate: map['orderDate'] ?? DateTime.now(),
      orderDate: DateTime.parse(map['orderDate'] ?? ''),

      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
