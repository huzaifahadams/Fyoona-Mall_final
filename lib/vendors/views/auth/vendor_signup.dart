// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyoona/vendors/views/auth/services/vendor_auth_services.dart';
import 'package:fyoona/vendors/views/auth/vendor_login.dart';
import 'package:image_picker/image_picker.dart';

import '../../../global_variables.dart';

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
  final TextEditingController __taxNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordsController.dispose();
    _fullnameController.dispose();
    _phonenNumberController.dispose();
    _bussinessNameController.dispose();
    _locationController.dispose();
    __taxNumberController.dispose();
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
      // __taxNumberController.text
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 80,
              ),
              const Text(
                'Create an account ',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  ListTile(
                    title: const Text('Select Logo'),
                    trailing: const Icon(Icons.image),
                    onTap: _selectLogo,
                  ),
                  _logo != null
                      ? Center(
                          child: Image.file(
                            File(_logo!.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Text(''),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _signupFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                              icon: Icon(Icons.email),
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
                              icon: Icon(Icons.person),
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
                              icon: Icon(Icons.phone),
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
                              icon: Icon(Icons.business),
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
                              icon: Icon(Icons.location_city),
                              labelText: 'Business  Location',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: __taxNumberController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.numbers),
                              labelText: 'Tax Number',
                            ),
                          ),
                        ),
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
                              icon: const Icon(Icons.password),
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
                        TextButton(
                          onPressed: () {
                            if (_signupFormKey.currentState!.validate()) {
                              signUpVendor();
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 50,
                            decoration: BoxDecoration(
                                color: fyoonaMainColor,
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
            ]),
          ),
        ));
  }
}
