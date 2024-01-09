// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyoona/const/images.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../global_variables.dart';
import '../providers/user_provider.dart';
import '../utils.dart';
import 'dart:convert'; // Import the 'dart:convert' library

class EditProfileScreen extends StatefulWidget {
  final dynamic user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _emalController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _newpassController = TextEditingController();

  String? address;
  String? password;
  @override
  void initState() {
    _fullNameController.text = widget.user.fullname;
    _emalController.text = widget.user.email;
    _phoneController.text = widget.user.phonenumber;
    _addressController.text = widget.user.address;
    super.initState();
  }

  updateUser() async {
    try {
      EasyLoading.show(status: 'Updating...');
      // Get the authentication token from the UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String authToken = userProvider.user.token;

      // Create a map of the data to send to the API
      Map<String, dynamic> data = {
        'fullName': _fullNameController.text,
        'email': _emalController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'newPassword': _newpassController.text,
      };

      // Convert the map to a JSON string
      String jsonData = jsonEncode(data);

      // Make the PUT request to your API with the authentication token in the headers
      final response = await http.put(
        Uri.parse('$uri/api/users/updateuser/${widget.user.id}'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: jsonData, // Use the JSON string as the request body
      );

      if (response.statusCode == 200) {
        // Successfully updated user data
        EasyLoading.dismiss();
        Navigator.of(context).pop();
      } else {
        // Handle API errors
        if (response.body
            .contains('Password must be at least 6 characters long')) {
          // Show Snackbar for password length error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password must be at least 6 characters long'),
              duration: Duration(seconds: 2),
            ),
          );
          EasyLoading.dismiss();

          return null;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update user data'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } on SocketException {
      showSnackBar(context, "Please check your internet connection.");
    } on TimeoutException {
      showSnackBar(context, "The request timed out. Please try again later.");
    } catch (e, stackTrace) {
      showSnackBar(
        context,
        "An error occurred while fetching products: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            letterSpacing: 3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: user.userImg != ''
                          ? NetworkImage(user.userImg!)
                          : const AssetImage(userImgz) as ImageProvider,
                      // backgroundColor: fyoonaMainColor,
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.photo),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _fullNameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Enter Full Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emalController,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Enter Phone number",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _addressController,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      address = value;
                    },
                    decoration: const InputDecoration(
                      labelText: "Enter Address",
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     controller: _oldpassController,
                //     keyboardType: TextInputType.text,
                //     onChanged: (value) {
                //       password = value;
                //     },
                //     decoration: const InputDecoration(
                //       labelText: "Enter Old Password",
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _newpassController,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                      labelText: "Enter New Password",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            // EasyLoading.show(status: 'Updating...');
            updateUser();
            // .whenComplete(() {
            //   EasyLoading.dismiss();
            //   Navigator.of(context).pop();
            // });
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: fyoonaMainColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'UPDATE',
                style: TextStyle(
                    color: Colors.white, fontSize: 18, letterSpacing: 6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
