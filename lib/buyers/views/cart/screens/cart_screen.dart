import 'package:flutter/material.dart';
import 'package:fyoona/buyers/views/nav_screens/widgets/address_box.dart';

import 'package:provider/provider.dart';

import '../../../../global_variables.dart';
import '../../../providers/user_provider.dart';
import '../../nav_screens/widgets/address/screens/address_screen.dart';
import '../../nav_screens/widgets/custom_button.dart';
import '../wigets/cart_product.dart';
import '../wigets/cart_subtotal.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void navigateToAddress(double sum) {
    Navigator.pushNamed(context, AddressScreen.routeName,
        arguments: sum.toString());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    // double sum = 0.0;
    // user.cart
    //     .map((e) => sum += e['quantity'] * e['product']['productPrice'])
    //     .toList();
    double sum = 0.0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['productPrice'] +
            (e['product']['shippingFee'] ?? 0.0))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: fyoonaMainColor,
        elevation: 0,
        title: const Text(
          'Shopping Cart',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            const CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (user.cart.isNotEmpty)
                  ? CustomButton(
                      text: 'Buy (${user.cart.length} items )',
                      onTap: () => navigateToAddress(sum),
                      color: fyoonaMainColor,
                    )
                  : const SizedBox(), // You can replace SizedBox() with any other widget or an empty container if you want to have a placeholder when the condition is not met.
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              color: Colors.black12.withOpacity(0.08),
              height: 1,
            ),
            const SizedBox(
              height: 5,
            ),
            ListView.builder(
              itemCount: user.cart.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartProduct(
                  index: index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
