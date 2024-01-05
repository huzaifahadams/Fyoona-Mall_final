// ignore_for_file: use_build_context_synchronously, avoid_print, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:fyoona/buyers/providers/user_provider.dart';
import 'package:fyoona/buyers/views/main_screen.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../../error_handling.dart';
import '../../../models/user.dart';
import '../../../utils.dart';
import '../../../../global_variables.dart';
import '../buyers_verification_screen.dart';
import '../user_login.dart';

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

class AuthService {
  // Add this line to declare the prefs field
  static late SharedPreferences prefs;
  // Method to log out the user
  // Add the context parameter
  Future<void> logOutUser(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Print the current value of the access token
      print('Current access token: ${prefs.getString('accessToken')}');

      // Check if the access token exists before removal
      if (prefs.containsKey('accessToken')) {
        bool success = await prefs.remove('accessToken');
        print('Token removal success: $success');

        // Clear the user token in the provider
        Provider.of<UserProvider>(context, listen: false).clearUserToken();
      } else {
        print('No access token found');
      }
    } catch (e) {
      print("Error in logOutUser: $e");
    }
  }

//singup user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String phonenumber,
    required String fullname,
    File? images,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dgysnizyn', 'snwj9yw0 ');
      //images
      String imageUrls = '';

      // for (int i = 0; i < images.length; i++) {
      //   CloudinaryResponse res = await cloudinary.uploadFile(
      //     CloudinaryFile.fromFile(images[i].path, folder: fullname),
      //   );
      //   imageUrls.add(res.secureUrl);
      // }
      if (images != null) {
        if (images != null) {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images.path, folder: fullname),
          );
          imageUrls = res.secureUrl;
        }
      }
      Buyer user = Buyer(
        id: '',
        fullname: fullname,
        password: password,
        phonenumber: phonenumber,
        address: '',
        token: '',
        email: email,
        userImg: imageUrls,
        cart: [],
      );
      print(user.toJson());
      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/registerbuyer'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
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
              builder: (context) => BuyersVerificationScreen(
                email: user.email,
              ),
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

  //get user  data
  //login user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/loginbuyer'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      // print(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          showSnackBar(
            context,
            'Account Logged in',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
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
        Uri.parse('$uri/api/auth/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        //get user daata
        http.Response userRes = await http.get(
          Uri.parse('$uri/api/auth/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred : ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
    }
  }
}
