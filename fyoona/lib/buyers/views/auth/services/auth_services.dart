import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyoona/buyers/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../error_handling.dart';
import '../../../../global_variables.dart';
import 'package:http/http.dart' as http;

import '../../../../utils.dart';
import '../../../models/user.dart';
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

class AuthService {
  Future<Uint8List?> pickProfileImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    } else {
      return null;
    }
  }

// Adjusted signUpUser method
  void signUpUser({
    required BuildContext context,
    required String jsonData,
    required Map<String, dynamic> data,
    Function? onSuccess, // Add this parameter
  }) async {
    if (isJson(jsonEncode(data))) {
      try {
        final cloudinary = CloudinaryPublic('dgysnizyn', 'snwj9yw0 ');

        // Convert the JSON data to a map
        Map<String, dynamic> data = jsonDecode(jsonData);

        // Extracting values from the data map
        String email = data['email'];
        String fullname = data['fullname'];
        String password = data['password'];
        String phonenumber = data['phonenumber'];
        String userImg = data['userImg'] ??
            ''; // Use an empty string if userImg is not present in the data map

        // Image upload to Cloudinary
        if (userImg.isNotEmpty) {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(userImg, folder: fullname),
          );
          // Update userImg with the Cloudinary secureUrl
          userImg = res.secureUrl;
        } else {
          // If userImg is null or empty, you can handle it accordingly
          // For now, let's set it to an empty string or any default value
          userImg = '';
        }

        // Create user object
        Buyer user = Buyer(
          email: email,
          phonenumber: phonenumber,
          fullname: fullname,
          password: password,
          userImg: userImg,
        );

        // Send the request
        http.Response res = await http.post(
          Uri.parse('$uri/api/auth/registerbuyer'),
          body: jsonEncode(user.toJson()), // Convert the user object to JSON
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        // Check for successful signup
        if (res.statusCode == 201) {
          onSuccess?.call(); // Call the onSuccess callback if provided
        } else {
          // Handle other response codes if needed
        }

        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            // Navigate to the login screen after successful signup
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BuyersLoginScreen(),
              ),
            );
            showSnackBar(
              context,
              'Account created! And Verify Email has sent to your email',
            );
          },
        );
      } on SocketException {
        showSnackBar(context, 'Please check your internet connection.');
      } on TimeoutException {
        showSnackBar(context, 'The request timed out. Please try again later.');
      } catch (e, stackTrace) {
        showSnackBar(
          context,
          'An error occurred while creating account: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}',
        );
      }
    } else {
      // The jsonData is not in valid JSON format
      // print('Invalid JSON format');
      // Handle the error accordingly
    }
  }

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

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // ignore: use_build_context_synchronously
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          // Navigator.pushNamedAndRemoveUntil(

          //     );
        },
      );
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred  while loggin in : ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
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
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        //get user daata
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        // ignore: use_build_context_synchronously
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e, stackTrace) {
      showSnackBar(context,
          "An error occurred : ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
    }
  }
}
