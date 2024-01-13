// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../providers/user_provider.dart';

// class CartSubtotal extends StatelessWidget {
//   const CartSubtotal({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<UserProvider>().user;

//     //getting the sub total
//     double sum = 0.0;
//     user.cart
//         .map((e) => sum += e['quantity'] * e['product']['productPrice'])
//         .toList();

//     return Container(
//       margin: const EdgeInsets.all(10),
//       child: Row(children: [
//         const Center(
//           child: Text(
//             'Subtotal',
//             style: TextStyle(
//               fontSize: 20,
//             ),
//           ),
//         ),
//         Text(
//           ' \$$sum',
//           style: const TextStyle(
//               fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
//         )
//       ]),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    // Getting the subtotal
    double sum = 0.0;
    for (var e in user.cart) {
      sum += e['quantity'] * e['product']['productPrice'];

      // Adding shipping fee if not null
      var shippingFee = e['product']['shippingFee'];
      if (shippingFee != null && shippingFee is num) {
        sum += shippingFee;
      }
    }

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Center(
            child: Text(
              'Subtotal',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Text(
            ' \$$sum',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
