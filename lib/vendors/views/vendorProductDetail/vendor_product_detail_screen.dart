import 'package:flutter/material.dart';

import '../../../const/styles.dart';
import '../../../global_variables.dart';
import '../../models/product.dart';
import '../services/products_services.dart';

class VendorProductDetailScreen extends StatefulWidget {
  // final dynamic productData;
  final Product productData; // Change dynamic to Product

  const VendorProductDetailScreen({super.key, required this.productData});

  @override
  State<VendorProductDetailScreen> createState() =>
      _VendorProductDetailScreenState();
}

class _VendorProductDetailScreenState extends State<VendorProductDetailScreen> {
  final TextEditingController _productNamecontroller = TextEditingController();
  final TextEditingController _brandNamecontroller = TextEditingController();
  final TextEditingController _quantitycontroller = TextEditingController();
  final TextEditingController _pricecontroller = TextEditingController();
  final TextEditingController _productinfocontroller = TextEditingController();
  final TextEditingController _productCategory = TextEditingController();
  @override
  void initState() {
    setState(() {
      _productNamecontroller.text = widget.productData.productName;
      _brandNamecontroller.text = widget.productData.brandName!;
      _quantitycontroller.text = widget.productData.quantity.toString();
      _pricecontroller.text = widget.productData.productPrice.toString();
      _productinfocontroller.text = widget.productData.productDescription;
      _productCategory.text = widget.productData.category.toString();
    });
    super.initState();
  }

  double? productPrice;
  int? productQuantity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: fyoonaMainColor,
        title: Text(
          widget.productData.productName,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _productNamecontroller,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _brandNamecontroller,
                decoration: const InputDecoration(labelText: 'Brand Name'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  productQuantity = int.parse(value);
                },
                controller: _quantitycontroller,
                decoration: const InputDecoration(labelText: 'Quatity '),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  productPrice = double.parse(value);
                },
                controller: _pricecontroller,
                decoration: const InputDecoration(labelText: 'Product Price'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                maxLength: 800,
                maxLines: 5,
                controller: _productinfocontroller,
                decoration:
                    const InputDecoration(labelText: 'product Description '),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                enabled: false,
                controller: _productCategory,
                decoration: const InputDecoration(labelText: 'Category '),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: () async {
            if (productPrice != null && productQuantity != null) {
              // Get updated values from controllers
              String updatedProductName = _productNamecontroller.text;
              String updatedBrandName = _brandNamecontroller.text;
              int updatedQuantity = int.parse(_quantitycontroller.text);
              double updatedPrice = double.parse(_pricecontroller.text);
              String updatedProductInfo = _productinfocontroller.text;
              String updatedProductCategory = _productCategory.text;

              // Prepare the updated data to be sent to the server
              Map<String, dynamic> updatedData = {
                'productName': updatedProductName,
                'brandName': updatedBrandName,
                'quantity': updatedQuantity,
                'productPrice': updatedPrice,
                'productDescription': updatedProductInfo,
                'category': updatedProductCategory,
              };

              // Call the updateProduct function
              await updateProduct(
                context: context,
                id: widget.productData.id
                    .toString(), // Assuming id is a property of your Product class
                updatedData: updatedData,
              );
              // Navigate back to the previous page
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              // ignore: use_build_context_synchronously
              ShowSnack2(context, 'Updated');

              // Perform any additional actions after updating if needed
            } else {
              ShowSnack(context, 'Update Quantity And Price');
            }
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: fyoonaMainColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
                child: Text(
              'UPDATE',
              style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 3,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ),
    );
  }
}
