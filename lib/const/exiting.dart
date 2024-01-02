import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyoona/const/colors.dart';
import 'package:fyoona/const/styles.dart';

Widget exitDialog(context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Confirm",
            style: TextStyle(
              fontFamily: bold,
              fontSize: 18,
              color: darkFontGrey,
            ),
          ),
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            "Are you sure you want to exit?",
            style: TextStyle(
              fontSize: 16,
              color: darkFontGrey,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: redColor),
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: whiteColor),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: redColor),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: whiteColor),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
