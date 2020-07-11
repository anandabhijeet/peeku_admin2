import 'package:flutter/material.dart';

class MyNavigator{
  static void goToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/homepage");
  }
}