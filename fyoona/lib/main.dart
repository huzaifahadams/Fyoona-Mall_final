import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyoona/const/styles.dart';
import 'package:fyoona/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const SplashScreen(),
    );
  }
}
