import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyoona/buyers/views/auth/user_login.dart';

import '../../../const/images.dart';

class BuyersRegisterScreen extends StatefulWidget {
  const BuyersRegisterScreen({super.key});

  @override
  State<BuyersRegisterScreen> createState() => _BuyersRegisterScreenState();
}

class _BuyersRegisterScreenState extends State<BuyersRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;
  late String fullName;
  late String phoneNumber;
  late String password;
  Uint8List? _image;
  final _isLoading = false;
  bool _isPasswordVisible = false;

  // late String _authController;
  // seletGalleryImage() async {
  //   Uint8List im = await _authController.pickProfileImage(ImageSource.gallery);

  //   setState(() {
  //     _image = im;
  //   });
  // }

  // seletPickCameraImage() async {
  //   Uint8List im = await _authController.pickProfileImage(ImageSource.camera);

  //   setState(() {
  //     _image = im;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable the back button

      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                        backgroundImage: _image != null
                            ? MemoryImage(_image!)
                            : const AssetImage(userImg) as ImageProvider,
                      ),
                      Positioned(
                        right: 0,
                        top: 5,
                        child: IconButton(
                          onPressed: () {
                            // seletGalleryImage();
                          },
                          icon: const Center(
                            child: Icon(
                              CupertinoIcons.photo,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Email must not be empty';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Full Name must not be empty';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        fullName = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Full name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Phone Number must not be empty';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Phone Number',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Password must not be empty';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        password = value;
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
                      // _signupUser();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.yellow.shade900,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: _isLoading
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
                              return const BuyersLoginScreen();
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
