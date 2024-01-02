import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool? _chargeShipping = false;
  // late double shippingFee;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ProdcutProvider productProvider =
        Provider.of<ProdcutProvider>(context);
    return Column(
      children: [
        CheckboxListTile(
          title: const Text(
            'Charge Shipping',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 4),
          ),
          value: _chargeShipping,
          onChanged: (value) {
            setState(() {
              _chargeShipping = value;
              productProvider.getFormData(chargeShipping: _chargeShipping);
            });
          },
        ),
        if (_chargeShipping == true)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Shipping Charge';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                // shippingFee = double.parse(value);
                productProvider.getFormData(shippingFee: double.parse(value));
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Shipping Charge'),
            ),
          ),
      ],
    );
  }
}
