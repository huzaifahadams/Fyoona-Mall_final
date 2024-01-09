import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyoona/buyers/providers/user_provider.dart';
import 'package:fyoona/const/styles.dart';
import 'package:fyoona/router.dart';
import 'package:fyoona/splashscreen.dart';
import 'package:fyoona/vendors/providers/product_provider.dart';
import 'package:fyoona/vendors/providers/vendor_provider.dart';
import 'package:fyoona/vendors/views/auth/services/vendor_auth_services.dart';
import 'package:provider/provider.dart';

import 'buyers/views/auth/services/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) {
        return ProdcutProvider();
      }),
      // add providers
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      ),
     
      ChangeNotifierProvider(
        create: (context) => VendorProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  final AuthServiceVendor authServiceVendor = AuthServiceVendor();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
          authServiceVendor.getUserData(context);

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: regular,
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
