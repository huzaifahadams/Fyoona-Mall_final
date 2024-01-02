import 'package:flutter/material.dart';

class ProdcutProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};
  getFormData({
    String? productName,
    double? productPrice,
    int? quantity,
    Object? category,
    String? productDescription,
    DateTime? scheduleDate,
    List<String>? imageUrList,
    String? mediaUrl,
    bool? chargeShipping,
    double? shippingFee,
    String? brandName,
    List<String>? sizeList,
    List<String>? colorList, 
    // ignore: non_constant_identifier_names
    String? VIdeoUrl,
  }) {
    if (productName != null) {
      productData['productName'] = productName;
    }
    if (productPrice != null) {
      productData['productPrice'] = productPrice;
    }
    if (quantity != null) {
      productData['quantity'] = quantity;
    }
    if (category != null) {
      productData['category'] = category;
    }
    if (productDescription != null) {
      productData['productDescription'] = productDescription;
    }
    if (scheduleDate != null) {
      productData['scheduleDate'] = scheduleDate;
    }
    if (imageUrList != null) {
      productData['imageUrList'] = imageUrList;
    }
    if (mediaUrl != null) {
      productData['mediaUrl'] = mediaUrl;
    }
    if (shippingFee != null) {
      productData['shippingFee'] = shippingFee;
    }
    if (chargeShipping != null) {
      productData['chargeShipping'] = chargeShipping;
    }
    if (brandName != null) {
      productData['brandName'] = brandName;
    }
    if (sizeList != null) {
      productData['sizeList'] = sizeList;
    }
    if (colorList != null) {
      productData['colorList'] = colorList;
    }

    notifyListeners();
  }

  clearData() {
    productData.clear();
    notifyListeners();
  }
}
