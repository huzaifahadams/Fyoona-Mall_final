import 'package:flutter/material.dart';
import 'package:fyoona/buyers/providers/user_provider.dart';
import 'package:fyoona/const/colors.dart';
import 'package:fyoona/vendors/providers/vendor_provider.dart';
import 'package:fyoona/vendors/views/auth/vendor_login.dart';
import 'package:fyoona/vendors/views/landing_screen.dart';
import 'package:fyoona/vendors/views/main_vendor_screen.dart';

import 'package:provider/provider.dart';

import 'buyers/views/auth/user_login.dart';
import 'buyers/views/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  changeScreen() async {
    await Future.delayed(const Duration(seconds: 1));

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? accessToken = prefs.getString('accessToken');

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      // Navigate to MainScreen if token is present, otherwise to BuyersLoginScreen
      return
          // Provider.of<UserProvider>(context).user.token.isNotEmpty
          //     ? Provider.of<UserProvider>(context).user.isBuyer == true
          //         ? const MainScreen()
          //         : Provider.of<VendorProvider>(context).user.token.isNotEmpty
          //                   // ? Provider.of<VendorProvider>(context).user.isVendor == true

          //             ? const MainVendorScreen()
          //             : const VendorLoginScreen()
          //     : const BuyersLoginScreen();

          // Provider.of<UserProvider>(context).user.token.isNotEmpty
          //     ? const MainScreen()
          //     : const BuyersLoginScreen();

          Provider.of<VendorProvider>(context).user.token.isNotEmpty
              ? LandingScreen()
              : const VendorLoginScreen();
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


// import 'package:flutter/material.dart';
// import 'package:fyoona/const/colors.dart';
// import 'package:fyoona/vendors/providers/vendor_provider.dart';
// import 'package:fyoona/vendors/views/auth/vendor_login.dart';
// import 'package:fyoona/vendors/views/landing_screen.dart';

// import 'package:provider/provider.dart';

// import 'buyers/providers/user_provider.dart';
// import 'buyers/views/auth/user_login.dart';
// import 'buyers/views/main_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   changeScreen() async {
//     await Future.delayed(const Duration(seconds: 1));

//     // ignore: use_build_context_synchronously
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
//       return Provider.of<UserProvider>(context).user.token.isNotEmpty
//           ? Provider.of<UserProvider>(context).user.type == 'isBuyer'
//               ? const MainScreen()
//               : Provider.of<VendorProvider>(context).user.type == 'isVendor' &&
//                       Provider.of<VendorProvider>(context).user.token.isNotEmpty
//                   ? LandingScreen()
//                   : const VendorLoginScreen()
//           : const BuyersLoginScreen();
//     }));
//   }

//   @override
//   void initState() {
//     changeScreen();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: yellowcolor,
//     );
//   }
// }
