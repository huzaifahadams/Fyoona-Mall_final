// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

const regular = "sans_regular";
const semibold = "sans_semibold";
const bold = "sans_bold";


ShowSnack(context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red.shade900, content: Text(title,style: const TextStyle(fontWeight:FontWeight.bold ,),)));
}

ShowSnack2(context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green.shade900, content: Text(title,style: const TextStyle(fontWeight:FontWeight.bold ,),)));
}
