import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyoona/vendors/providers/product_provider.dart';
import 'package:fyoona/vendors/views/main_vendor_screen.dart';
import 'package:fyoona/vendors/views/services/products_services.dart';
import 'package:fyoona/vendors/views/upload_tap_screens/general_screen.dart';
import 'package:fyoona/vendors/views/upload_tap_screens/images_tab_screen.dart';
import 'package:provider/provider.dart';

import '../../../global_variables.dart';
import '../../providers/vendor_provider.dart';
import '../upload_tap_screens/attributes_tab_screen.dart';
import '../upload_tap_screens/shipping_screen.dart';
import '../upload_tap_screens/video_tab_screen.dart';

class UploadsScreen extends StatelessWidget {
  final _addProductFormKey = GlobalKey<FormState>();
  final ProductsServcies productServcies = ProductsServcies();

  UploadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProdcutProvider productProvider =
        Provider.of<ProdcutProvider>(context);
    final user = Provider.of<VendorProvider>(context).user;

    return DefaultTabController(
      length: 5,
      child: Form(
        key: _addProductFormKey,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading:
                false, // Set this to false to hide the back button

            backgroundColor: fyoonaMainColor,
            elevation: 0,
            bottom: const TabBar(tabs: [
              Tab(
                child: Text('General'),
              ),
              Tab(
                child: Text('Shipping'),
              ),
              Tab(
                child: Text('Attributes'),
              ),
              Tab(
                child: Text('Images'),
              ),
              Tab(
                child: Text('Video'),
              ),
            ]),
          ),
          body: const TabBarView(children: [
            GeneralScreen(),
            ShippingScreen(),
            AttributesTabScreen(),
            ImagesTabScreen(),
            VideoTabScreen(),
          ]),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: fyoonaMainColor,
              ),
              onPressed: () async {
                if (_addProductFormKey.currentState!.validate()) {
                  // EasyLoading.show(status: 'Saving please wait....');
                  if (productProvider.productData['scheduleDate'] == null ||
                      productProvider.productData['scheduleDate'].isEmptyll ||
                      productProvider.productData['imageUrList'] == null ||
                      productProvider.productData['imageUrList'].isEmpty ||
                      productProvider.productData['mediaUrl'] == null ||
                      productProvider.productData['mediaUrl'].isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all required fields'),
                      ),
                    );
                  } else {
                    EasyLoading.show(status: 'Saving please wait....');

                    await productServcies
                        .sellProduct(
                      context: context,
                      productName: productProvider.productData['productName'],
                      productPrice: productProvider.productData['productPrice']
                          .toDouble(),
                      quantity: productProvider.productData['quantity'],
                      category: productProvider.productData['category'],
                      productDescription:
                          productProvider.productData['productDescription'],
                      imageUrList: productProvider.productData['imageUrList'],
                      videoUrl: productProvider.productData['mediaUrl'],
                      // if(                    scheduleDate: productProvider.productData['scheduleDate'] == null)
                      // ShowSnakBar(Text'Selecet date')

                      scheduleDate: productProvider.productData['scheduleDate'],
                      chargeShipping:
                          productProvider.productData['chargeShipping'],
                      shippingFee: productProvider.productData['shippingFee'],
                      brandName: productProvider.productData['brandName'],
                      // sizeList: productProvider.productData['sizeList'],
                      colorList: productProvider.productData['colorList'],
                      vendorId: user.id,
                      approved: productProvider.productData['approved'],
                    )
                        .whenComplete(() {
                      productProvider.clearData();
                      _addProductFormKey.currentState!.reset();
                      EasyLoading.dismiss();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainVendorScreen(),
                        ),
                      );
                    });
                  }
                }
              },
              child: const Text('Save'),
            ),
          ),
        ),
      ),
    );
  }
}
