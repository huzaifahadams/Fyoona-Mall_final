// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyoona/vendors/views/auth/services/vendor_auth_services.dart';
import 'package:fyoona/vendors/views/auth/vendor_login.dart';
import 'package:image_picker/image_picker.dart';

class VendorSignupScreen extends StatefulWidget {
  const VendorSignupScreen({super.key});

  @override
  State<VendorSignupScreen> createState() => _VendorSignupScreenState();
}

class _VendorSignupScreenState extends State<VendorSignupScreen> {
  final AuthServiceVendor authService = AuthServiceVendor();

  final _signupFormKey = GlobalKey<FormState>(); //form for signup

  File? _logo; // This will store the selected logo file

  bool isLoading = false;
  bool _isPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordsController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phonenNumberController = TextEditingController();

  final TextEditingController _bussinessNameController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  // final TextEditingController __taxNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordsController.dispose();
    _fullnameController.dispose();
    _phonenNumberController.dispose();
    _bussinessNameController.dispose();
    _locationController.dispose();
  }

  void signUpVendor() async {
    setState(() {
      isLoading = true;
    });

    authService.signUpVendor(
      context: context,
      email: _emailController.text,
      password: _passwordsController.text,
      phonenumber: _phonenNumberController.text,
      fullname: _fullnameController.text,
      location: _locationController.text,
      images: _logo,
      businessname: _bussinessNameController.text,
    );

    setState(() {
      isLoading = false;
    });
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _selectLogo() async {
    // ignore: no_leading_underscores_for_local_identifiers

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
    } else {
      setState(() {
        _logo = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable the back button

      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _signupFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create an account ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: _logo != null
                            ? Image.file(
                                File(_logo!.path),
                                width:
                                    100, // Set the width of the displayed image
                                height:
                                    100, // Set the height of the displayed image
                                fit: BoxFit.cover,
                              ).image
                            : null,
                        child: _logo == null
                            ? const Center(
                                child: Text(
                                  'ENTER LOGO',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        top: 5,
                        child: IconButton(
                          onPressed: () {
                            _selectLogo(); // Updated function call
                          },
                          icon: const Center(
                            child: Center(
                              child: Icon(
                                Icons.image,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Email must not be empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _fullnameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Full Name must not be empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Full name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _phonenNumberController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Phone Number must not be empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Phone Number',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _bussinessNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Business Name';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Business  Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _locationController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Business Loction';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Business  Location',
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: TextFormField(
                  //     controller: __taxNumberController,
                  //     keyboardType: TextInputType.number,
                  //     decoration: const InputDecoration(
                  //       labelText: 'Tax Number',
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _passwordsController,
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Password must not be empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          color: Colors.black,
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_signupFormKey.currentState!.validate()) {
                        signUpVendor();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 245, 23, 164),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Regester',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 4),
                                )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already Have An Account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const VendorLoginScreen();
                            }));
                          },
                          child: const Text('Login'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
