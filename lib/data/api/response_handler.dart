import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResponseHandler {
  static String of(http.Response response, {BuildContext context}) {
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    } else {
      switch (response.statusCode) {
        case 401:
          return null;
        default:
          print(json.decode(response.body)['message']);
          return null;
      }
    }
  }
}
