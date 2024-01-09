// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyoona/vendors/models/product.dart';
import 'package:fyoona/vendors/views/services/products_services.dart';
import 'package:provider/provider.dart';

import '../../../global_variables.dart';
import '../../providers/vendor_provider.dart';
import '../vendorProductDetail/vendor_product_detail_screen.dart';

// ignore: use_key_in_widget_constructors
class UnpubLishedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final user = Provider.of<VendorProvider>(context).user;

    return Scaffold(
      body: FutureBuilder<List<Product>>(
        future: fetchAllProductsvendor2(context),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: fyoonaMainColor,
              ),
            );
          }

          final List<Product>? productList = snapshot.data;

          if (productList == null || productList.isEmpty) {
            return const Center(
              child: Text(
                'No Unpublished Products',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final Product vendorProductData = productList[index];

                return Slidable(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return VendorProductDetailScreen(
                          productData: vendorProductData,
                        );
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child:
                                Image.network(vendorProductData.imageUrList[0]),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vendorProductData.productName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                // ignore: prefer_adjacent_string_concatenation
                                '\$' +
                                    ' ' +
                                    vendorProductData.productPrice
                                        .toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: fyoonaMainColor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Specify a key if the Slidable is dismissible.
                  key: const ValueKey(0),

                  // The start action pane is the one at the left or the top side.
                  startActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // All actions are defined in the children parameter.
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        flex: 2,
                        onPressed: (context) async {
                          // Call the function to update the product to approved
                          await updateProduct(
                            context: context,
                            id: vendorProductData.id.toString(),
                            updatedData: {'approved': true},
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                        backgroundColor: const Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.approval_sharp,
                        label: 'Publish',
                      ),
                      SlidableAction(
                        flex: 2,
                        onPressed: (context) async {
                          // Call the function to delete the product
                          await delteProduct(
                              context: context,
                              product: vendorProductData,
                              onSuccess: () {
                                // Handle success if needed
                              });
                        },
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
