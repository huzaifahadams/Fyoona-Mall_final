import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyoona/buyers/views/auth/user_login.dart';

import '../../../const/images.dart';
import '../../utils.dart';
import 'services/auth_services.dart';

class BuyersRegisterScreen extends StatefulWidget {
  const BuyersRegisterScreen({super.key});

  @override
  State<BuyersRegisterScreen> createState() => _BuyersRegisterScreenState();
}

class _BuyersRegisterScreenState extends State<BuyersRegisterScreen> {
  final AuthService authService = AuthService();
  final _signUpFormKey = GlobalKey<FormState>(); //form for signup

  bool isLoading = false;
  bool _isPasswordVisible = false;
  List<File> images = []; //image thing

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordsController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phonenNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordsController.dispose();
    _fullnameController.dispose();
    _phonenNumberController.dispose();
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });

    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordsController.text,
      phonenumber: _phonenNumberController.text,
      fullname: _fullnameController.text,
      // userImg: images
    );

    setState(() {
      isLoading = false;
    });
  }

  void selctImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable the back button

      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _signUpFormKey,
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
                        backgroundImage: images.isNotEmpty
                            ? Image.file(
                                images.first,
                                fit: BoxFit.cover,
                                height: 200,
                              ).image // Use the image property to get ImageProvider<Object>
                            : const AssetImage(userImgz),
                      ),
                      Positioned(
                        right: 0,
                        top: 5,
                        child: IconButton(
                          onPressed: () {
                            selctImages(); // Updated function call
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
                      controller: _emailController, // Set the controller
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an email';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        // No need to assign to email here
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _fullnameController, // Set the controller
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Full Name must not be empty';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        // No need to setState for fullname here
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Full name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _phonenNumberController, // Set the controller
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Phone Number must not be empty';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        // No need to setState for phoneNumber here
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Phone Number',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _passwordsController, // Set the controller
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Password must not be empty';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        // No need to setState for password here
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
                      if (_signUpFormKey.currentState!.validate()) {
                        signUpUser();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.yellow.shade900,
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
