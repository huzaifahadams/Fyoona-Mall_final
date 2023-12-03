import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyoona/utils.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
 
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      try {
        // Try to decode the error message from the response body
        final errorJson = jsonDecode(response.body);
        final errorMessage = errorJson is String ? errorJson : errorJson['msg'];
        showSnackBar(context, errorMessage);
      } catch (e) {
        // If decoding fails or it's not a JSON structure, use the entire response body as the error message
        showSnackBar(context, 'Bad request: ${response.body}');
      }
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;
    default:
      showSnackBar(context, response.body);
  }
}
