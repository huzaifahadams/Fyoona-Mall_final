// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyoona/vendors/views/main_vendor_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../buyers/utils.dart';
import '../../../global_variables.dart';
import '../../providers/vendor_provider.dart';

// ignore: use_key_in_widget_constructors
class VendorWithdrawScreen extends StatefulWidget {
  @override
  State<VendorWithdrawScreen> createState() => _VendorWithdrawScreenState();
}

class _VendorWithdrawScreenState extends State<VendorWithdrawScreen> {
  // final TextEditingController amountController = TextEditingController();
  late String amount;

  late String name;

  late String mobile;

  late String bankName;

  late String bankAccountName;

  late String bankAccountNumber;

  // Future<Map<String, dynamic>> sendWithdrawalRequest(
  //   String amount,
  //   String name,
  //   String mobile,
  //   String bankName,
  //   String bankAccountName,
  //   String bankAccountNumber,
  // ) async {
  //   final userProvider = Provider.of<VendorProvider>(context, listen: false);
  //   final url = Uri.parse('$uri/api/vendor/add-withdrawal');

  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'x-auth-token': userProvider.user.token,
  //     },
  //     body: jsonEncode({
  //       'amount': amount,
  //       'name': name,
  //       'mobile': mobile,
  //       'bankName': bankName,
  //       'bankAccountName': bankAccountName,
  //       'bankAccountNumber': bankAccountNumber,
  //       'vendorId': userProvider.user.id
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     // Successful response
  //     return {'success': true};
  //   } else {
  //     // Error response
  //     final responseBody = jsonDecode(response.body);
  //     return {
  //       'success': false,
  //       'error': responseBody['error'] ?? 'An error occurred'
  //     };

  //   }

  // }
  Future<Map<String, dynamic>> sendWithdrawalRequest(
    String amount,
    String name,
    String mobile,
    String bankName,
    String bankAccountName,
    String bankAccountNumber,
    BuildContext context, // Make sure to include BuildContext as a parameter
  ) async {
    try {
      final userProvider = Provider.of<VendorProvider>(context, listen: false);
      final url = Uri.parse('$uri/api/vendor/add-withdrawal');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'amount': amount,
          'name': name,
          'mobile': mobile,
          'bankName': bankName,
          'bankAccountName': bankAccountName,
          'bankAccountNumber': bankAccountNumber,
          'vendorId': userProvider.user.id,
        }),
      );

      if (response.statusCode == 200) {
        // Successful response
        return {'success': true};
      } else {
        // Error response
        final responseBody = jsonDecode(response.body);
        return {
          'success': false,
          'error': responseBody['error'] ?? 'An error occurred',
        };
      }
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
      return {'success': false, 'error': 'No internet connection'};
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
      return {'success': false, 'error': 'Request timed out'};
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred : ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");

      return {
        'success': false,
        'error': 'An error occurred: ${e.toString()}',
      };
    }
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        elevation: 0,
        title: const Text(
          'Withdraw',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 6,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please This must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    amount = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please This must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    name = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please This must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    mobile = value;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Mobile'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please This must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankName = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Bank Name'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please This must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankAccountName = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration:
                      const InputDecoration(labelText: 'Bank Account Name'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please This must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankAccountNumber = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Bank Account Number'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      final response = await sendWithdrawalRequest(
                        amount,
                        name,
                        mobile,
                        bankName,
                        bankAccountName,
                        bankAccountNumber,
                        context, // Make sure to include BuildContext as a parameter
                      );

                      if (response['success']) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Withdrawal request submitted successfully")),
                        );
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const MainVendorScreen();
                        }));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  response['error'] ?? "An error occurred")),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Get Cash',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
