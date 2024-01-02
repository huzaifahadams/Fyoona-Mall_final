import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fyoona/buyers/models/user.dart';
import 'package:fyoona/buyers/providers/user_provider.dart';
import 'package:fyoona/buyers/views/nav_screens/widgets/address/services/address_servicess.dart';
import 'package:fyoona/buyers/views/nav_screens/widgets/custom_textfield.dart';

import 'package:provider/provider.dart';

import '../../../../../../const/colors.dart';
import '../../../../../../const/styles.dart';
import '../../../../../../global_variables.dart';
import '../../../../../utils.dart';
import 'package:http/http.dart' as http;

import '../../custom_button.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;

  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController houseBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final AddressServcies addressServcies = AddressServcies();

  final _addressFormKey = GlobalKey<FormState>();
  String addressTuse = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    houseBuildingController.dispose();
    areaController.dispose();
    zipcodeController.dispose();
    cityController.dispose();
  }

  Future<void> initPaymentSheet(String totalAmount, Buyer user) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/api/checkout/payment'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'amount': (double.parse(widget.totalAmount) * 100).toInt(),
          'email': user.email,
          'name': user.fullname,
        }),
      );

      final data = json.decode(response.body);

      final paymentIntent = data['paymentIntent'];
      final ephemeralKey = data['ephemeralKey'];
      final customer = data['customer'];
      final publishableKey = data['publishableKey'];

      Stripe.publishableKey = publishableKey;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Fyoona Mall',
          paymentIntentClientSecret: paymentIntent,
          customerEphemeralKeySecret: ephemeralKey,
          customerId: customer,
          style: ThemeMode.light,
          applePay: null, // Disable Apple Pay
          googlePay: null, // Disable Google Pay
        ),
      );

      await Stripe.instance.presentPaymentSheet().then((value) {
        ShowSnack2(context, ('Payment successful'));
        addressSaveAndorderSave(); // Call your addressSaveAndorderSave function
      }).onError((error, stackTrace) {
        if (error is StripeException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error.error.localizedMessage}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Stripe Error: $error')),
          );
        }
      });
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred while saving address : ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
    }
  }

  void addressSaveAndorderSave() {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServcies.saveUserAddress(context: context, address: addressTuse);
    }
    addressServcies.placeOrder(
      context,
      addressTuse,
      double.parse(
        widget.totalAmount.toString(),
      ),
    );
  }

//valdating button for address
  void payPressed(
    String addressFromProvider,
    Buyer user,
  ) {
    addressTuse = '';

    bool isForm = houseBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        zipcodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressTuse =
            '${houseBuildingController.text}, ${areaController.text}, ${cityController.text} - ${zipcodeController.text}';
        initPaymentSheet(widget.totalAmount, user);
      } else {
        throw Exception('Please fill  all values');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressTuse = addressFromProvider;
      // paymentstripe
      initPaymentSheet(widget.totalAmount, user);
    } else {
      showSnackBar(context, 'ERROR');
      // addressSave(addressTuse);
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    var user =
        context.watch<UserProvider>().user; // Make sure you have this line

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: houseBuildingController,
                      hintText: 'House No, Building ',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: areaController,
                      hintText: 'Area, Street',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: zipcodeController,
                      hintText: 'ZipCode',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      // obscureText: true,
                      controller: cityController,
                      hintText: 'City/Town ',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                text: 'Check Out',
                onTap: () async {
                  payPressed(address, user);
                },
                color: yellowcolor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
