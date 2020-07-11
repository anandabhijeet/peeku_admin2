import 'package:flutter/material.dart';
import 'package:peeku_admin2/loginScreen.dart';

import 'homepage.dart';
void main() =>runApp(Peeku());

class Peeku extends StatelessWidget {

  var routes = <String, WidgetBuilder>{
    "/homepage": (BuildContext context) => Homepage(),
  };


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: LoginScreen(),  routes: routes,
    );
  }
}
