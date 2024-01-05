import 'package:flutter/material.dart';
import 'package:fyoona/buyers/views/auth/user_login.dart';
import 'package:fyoona/vendors/views/auth/forget_pass_vendor.dart';
import 'package:fyoona/vendors/views/auth/services/vendor_auth_services.dart';
import 'package:fyoona/vendors/views/auth/vendor_signup.dart';

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({
    super.key,
  });

  @override
  State<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  final _signInUserFormKey = GlobalKey<FormState>(); //form for signup
  final AuthServiceVendor authService = AuthServiceVendor();

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
                      if (_signInUserFormKey.currentState!.validate()) {
                        signInUser();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 245, 23, 164),
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
                            return const VendorSignupScreen();
                          }));
                        },
                        child: const Text('Regester'),
                      ),
                      const Text(
                        'Buyer ?',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const BuyersLoginScreen();
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
                            return const ResetPasswordScreenVendor();
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
