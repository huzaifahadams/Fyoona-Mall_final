import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyoona/buyers/utils.dart';
import 'package:fyoona/vendors/views/auth/vendor_login.dart';
import 'package:http/http.dart' as http;

import '../../../buyers/error_handling.dart';
import '../../../global_variables.dart';

class ResetPasswordScreenVendor extends StatefulWidget {
  const ResetPasswordScreenVendor({super.key});

  @override
  State<ResetPasswordScreenVendor> createState() =>
      ResetPasswordScreenVendorState();
}

class ResetPasswordScreenVendorState extends State<ResetPasswordScreenVendor> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _isLoading = false;

// / Add the resetPassword function
  Future<void> resetPassword(String email) async {
    try {
      final Map<String, String> requestBody = {'email': email};

      final http.Response res = await http.post(
        Uri.parse('$uri/api/vendorauth/reset-password'),
        body: jsonEncode(requestBody),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'New password sent successfully. Check your email for the new password.',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const VendorLoginScreen(),
            ),
          );
        },
      );
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred while resetting password: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Password Reset'),
        backgroundColor: fyoonaMainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't worry! Enter your email, and if the email is registered, you will receive a password reset link.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await resetPassword(_emailController.text);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                    color: fyoonaMainColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Reset Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
