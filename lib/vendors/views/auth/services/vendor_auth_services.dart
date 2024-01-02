// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyoona/vendors/models/vendor.dart';
import 'package:fyoona/vendors/providers/vendor_provider.dart';
import 'package:fyoona/vendors/views/auth/vendor_login.dart';
import 'package:fyoona/vendors/views/landing_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../../../buyers/error_handling.dart';
import '../../../../buyers/utils.dart';
import '../../../../global_variables.dart';

// Define the isJson function outside of the AuthService class
bool isJson(String input) {
  try {
    jsonDecode(input);
    return true;
  } catch (e) {
    return false;
  }
}

late SharedPreferences prefs;

class AuthServiceVendor {
  // Add this line to declare the prefs field
  static late SharedPreferences prefs;

  // Method to log out the user

  Future<void> logOutVendor() async {
    try {
      // Your logout logic here
      // Clear user data, tokens, etc.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('accessToken');
      prefs.remove('refreshToken');
      // You can also perform other logout-related tasks here, such as clearing user data, etc.
    } catch (e) {
      print("Error in logOutUser: $e");
    }
  }

  // Future<Uint8List?> pickProfileImage(ImageSource source) async {
  //   final ImagePicker imagePicker = ImagePicker();
  //   XFile? file = await imagePicker.pickImage(source: source);
  //   if (file != null) {
  //     return await file.readAsBytes();
  //   } else {
  //     return null;
  //   }
  // }

// Add these methods in AuthService.dart
  Future<void> verifyCode({
    required BuildContext context,
    required String email,
    required String code,
  }) async {
    // Add logic to send the verification code to your backend and handle the response
    // If the code is correct, update the user's activation status and navigate to the login screen
  }

  Future<void> resendVerificationEmail(
      BuildContext context, String email) async {
    // Add logic to resend the verification email to your backend and handle the response
  }

  Future<Uint8List?> pickProfileImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    } else {
      return null;
    }
  }

  Future<String?> uploadImageToCloudinary(
      Uint8List images, String fullname) async {
    try {
      final cloudinary = CloudinaryPublic('dgysnizyn', 'snwj9yw0');
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(images.toString(), folder: fullname),
      );
      return response.secureUrl;
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
      return null;
    }
  }

//signup vendor
  Future<void> signUpVendor({
    required BuildContext context,
    required String email,
    required String password,
    required String phonenumber,
    required String fullname,
    required String location,
    required String businessname,
    Uint8List? images,
  }) async {
    try {
      String? imageUrl;

      // Check if an image is selected
      if (images != null) {
        // Upload the image to Cloudinary and get the URL
        imageUrl = await uploadImageToCloudinary(images, fullname);
      }

      Vendor user = Vendor(
        id: '',
        fullname: fullname,
        password: password,
        phonenumber: phonenumber,
        location: location,
        token: '',
        email: email,
        vendorlogo: imageUrl.toString(),
        businessname: businessname,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/vendorauth/registervendor'),
        body: user.toJson(),
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
            'Account created! And Verify Email has sent to your email',
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
          "An error occurred while creating account: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
    }
  }

  //get user  data
  //login vendor
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/vendorauth/loginvendor'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<VendorProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          showSnackBar(
            context,
            'Account Logged in',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LandingScreen(),
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
          "An error occurred  while loggin in : ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");

      // "An error occurred while fetching products: ${e.toString()}");
    }
  }

  //get user  data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/vendorauth/tokenIsValidVendor'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        //get user daata
        http.Response userRes = await http.get(
          Uri.parse('$uri/vendorauth/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var vendorProvider =
            Provider.of<VendorProvider>(context, listen: false);
        vendorProvider.setUser(userRes.body);
      }
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred : ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
    }
  }
}
