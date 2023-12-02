import 'package:flutter/material.dart';
import 'package:fyoona/const/colors.dart';

import 'buyers/views/auth/user_login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  changeScreen() async {
    await Future.delayed(const Duration(seconds: 1));

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const BuyersLoginScreen();
    }));
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowcolor,
    );
  }
}
