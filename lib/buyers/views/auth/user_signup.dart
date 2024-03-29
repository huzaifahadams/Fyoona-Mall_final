import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyoona/buyers/views/auth/user_login.dart';
import 'package:image_picker/image_picker.dart';

import '../../../const/images.dart';
import '../../../global_variables.dart';
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
  File? _logo; // This will store the selected logo file

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
        userImg: _logo);

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
                        backgroundImage: _logo != null
                            ? Image.file(
                                File(_logo!.path),
                                width:
                                    100, // Set the width of the displayed image
                                height:
                                    100, // Set the height of the displayed image
                                fit: BoxFit.cover,
                              ).image
                            : const AssetImage(userImgz),
                      ),
                      Positioned(
                        right: 0,
                        top: 5,
                        child: IconButton(
                          onPressed: () {
                            _selectLogo(); // Updated function call
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
                        icon: Icon(Icons.email),
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
                        icon: Icon(Icons.person),
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
                                                icon: Icon(Icons.phone),

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
                                                icon: const Icon(Icons.password),

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
                      if (_signUpFormKey.currentState!.validate()) {
                        signUpUser();
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
