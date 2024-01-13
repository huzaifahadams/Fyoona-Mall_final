import 'package:flutter/material.dart';

// String uri = 'http://192.168.16.19:8000'; //good
String uri = 'https://fyoona-64126387e533.herokuapp.com';

// String uri = 'https://fyoonaserver.onrender.com'; //bad

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
    stops: [0.5, 1.0],
  );

  static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static const Color fyoonaColor = Color.fromARGB(255, 14, 224, 24);
}

/// cloudinary
///
const iduser = 'dgysnizyn';
const idpass = 'snwj9yw0';
Color fyoonaMainColor = Colors.yellow.shade900;
