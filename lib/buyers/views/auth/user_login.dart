import 'package:flutter/material.dart';
import 'package:fyoona/buyers/views/auth/services/auth_services.dart';
import 'package:fyoona/buyers/views/auth/user_signup.dart';
import 'package:fyoona/global_variables.dart';
// import 'package:fyoona/const/images.dart';
import 'package:fyoona/vendors/views/auth/vendor_login.dart';

import 'forget_pass.dart';

class BuyersLoginScreen extends StatefulWidget {
  const BuyersLoginScreen({
    super.key,
  });

  @override
  State<BuyersLoginScreen> createState() => _BuyersLoginScreenState();
}

class _BuyersLoginScreenState extends State<BuyersLoginScreen> {
  final _signInUserFormKey = GlobalKey<FormState>(); //form for signup
  final AuthService authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordsController.dispose();
  }

  late String email;
  late String password;
  bool _isLoading = false;

  bool _isPasswordVisible = false;

  void signInUser() {
    setState(() {
      _isLoading = true; // Set loading to true when starting the login process
    });

    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordsController.text,
    );

    setState(() {
      _isLoading = false;
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
              key: _signInUserFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
                      // EasyLoading.show(status: 'loading...');

                      if (_signInUserFormKey.currentState!.validate()) {
                        signInUser();
                        // EasyLoading.dismiss();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                          color: fyoonaMainColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 4),
                                )),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () async {
                  //     // Call the Google Sign-In method
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(10.0),
                  //     child: Container(
                  //       width: MediaQuery.of(context).size.width - 40,
                  //       height: 50,
                  //       decoration: BoxDecoration(
                  //         color: Colors
                  //             .white, // Set the background color for the button
                  //         borderRadius: BorderRadius.circular(10),
                  //         border: Border.all(
                  //             color: Colors.grey), // Set the border color
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Image.asset(
                  //             googleIco,
                  //             width: 50, // Adjust the width as needed
                  //             height: 50, // Adjust the height as needed
                  //           ),
                  //           const SizedBox(width: 10),

                  //           const Text(
                  //             'Sign in with Google',
                  //             style: TextStyle(
                  //               color: Colors.black, // Set the text color
                  //               fontSize: 16, // Adjust the font size as needed
                  //             ),
                  //           ),
                  //           // Add some space between the image and text
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No  Account?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const BuyersRegisterScreen();
                          }));
                        },
                        child: const Text('Regester'),
                      ),
                      const Text(
                        'Seller ?',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const VendorLoginScreen();
                          }));
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const ResetPasswordScreen();
                          }));
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
