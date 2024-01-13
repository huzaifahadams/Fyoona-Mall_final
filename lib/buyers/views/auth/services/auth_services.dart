// ignore_for_file: use_build_context_synchronously, avoid_print, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:fyoona/buyers/providers/user_provider.dart';
import 'package:fyoona/buyers/views/auth/user_login.dart';
import 'package:fyoona/buyers/views/main_screen.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../../error_handling.dart';
import '../../../models/user.dart';
import '../../../utils.dart';
import '../../../../global_variables.dart';
import '../buyers_verification_screen.dart';

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
    required File? userImg,
  }) async {
    try {
      //images
      String? imageUrls;

      if (userImg != null) {
        final cloudinary = CloudinaryPublic(iduser, idpass);

        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(userImg.path, folder: fullname),
        );
        imageUrls = res.secureUrl;
      }

      Buyer user = Buyer(
        id: '',
        fullname: fullname,
        password: password,
        phonenumber: phonenumber,
        address: '',
        token: '',
        type: 'IsBuyer',
        email: email,
        userImg: imageUrls,
        cart: [],
      );
      // print(user.toJson());
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

  // Resend verification email
  Future<void> resendVerificationEmail(
      BuildContext context, String email) async {
    try {
      final Map<String, String> requestBody = {'email': email};

      final http.Response res = await http.post(
        Uri.parse('$uri/api/auth/resend-verification-email'),
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
            'Verification email resent successfully',
          );
        },
      );
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred while resending verification email: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
    }
  }

  // Verify email with code
  Future<void> verifyCode({
    required BuildContext context,
    required String email,
    required String code,
  }) async {
    try {
      final Map<String, String> requestBody = {'email': email, 'code': code};

      final http.Response res = await http.post(
        Uri.parse('$uri/api/auth/verify-email'),
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
            'Email successfully verified',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BuyersLoginScreen(),
            ),
          ); // Navigate to the login screen or perform any other actions as needed
        },
      );
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred while verifying email: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      AuthService authService =
          AuthService(); // Create an instance of AuthService
      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/loginbuyer'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var responseBody = jsonDecode(res.body);

          // Check if the user is activated
          var activationStatus = responseBody['isActivated'];
          if (!activationStatus) {
            // User is not activated, show a snackbar
            showSnackBar(
              context,
              'Account not activated. Check your email for activation instructions.',
            );

            // Use authService to resend verification email
            await authService.resendVerificationEmail(context, email);
            showSnackBar(
              context,
              'Verification email resent successfully',
            );

            // Navigate to BuyersVerificationScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BuyersVerificationScreen(email: email),
              ),
            );
          } else {
            // User is activated, proceed with the login
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await prefs.setString('x-auth-token', responseBody['token']);
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
          }
        },
      );
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(
        context,
        "An error occurred while logging in: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}",
      );
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
