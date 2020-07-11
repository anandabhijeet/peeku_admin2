import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:peeku_admin2/homepage.dart';

import 'package:shared_preferences/shared_preferences.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  var email = '';
  var password = '';
  TextEditingController _emailcontroller;
  TextEditingController _passwordcontroller;
  FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  gradient:LinearGradient(
                      colors:[
                        Colors.white,
                        Colors.blueGrey[300],
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  ),
                ),
              ),

            ),
            SafeArea(
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: 30.0, bottom: 15.0),
                    child: Container(

                      padding: EdgeInsets.only(top: 10, bottom: 5, left: 5.0),

                      child: Column( mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 50 ,
                            backgroundColor: Colors.yellow,
                            child: Text(
                              'P.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 60,
                                  color: Colors.black
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              'PeeKu',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                              ),
                            ),
                          )
                        ],

                      ),
                    ),
                  ),
                  Container(

                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 40.0),
                            child: Text(
                              'Log in to your account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40.0, right: 40.0),
                    child: TextField(
                      autofocus: true,
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                          labelText: 'Email address',
                          hintText: 'Enter your Email address',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),

                          )
                      ),
                      onChanged: (String value) {
                        setState(() {
                          email = value;
                        });
                        print(email);
                      },
                      onSubmitted: (String value) {

                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40.0, right: 40.0),
                    child: TextField(
                      autofocus: true,
                      controller: _passwordcontroller,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),

                          )
                      ),
                      onChanged: (String value) {
                        setState(() {
                          password = value;
                        });
                        print(password);
                      },
                      onSubmitted: (String value) {

                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40, right: 40, top: 30),
                    child: RaisedButton(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      color: Colors.yellow,
                      child: Text(
                        'Log In',
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: (){
                        loginCall();

                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  loginCall() async {
    final url = 'http://165.22.214.234:9000/auth';
    final response = await http.post(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Basic ' + base64.encode(utf8.encode(email + ':'+ password))
    });
    print(response.statusCode);
    if (response.statusCode == 201) {
//    writeToFile(json.decode(response.body));
      var res = json.decode(response.body);
      print(res);
      var token = res['token'];
      print(token);
      // _save(json.decode(response.body).token);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      Navigator.pushReplacementNamed(context, "/homepage");
    } else {
      throw Exception('unable to get data');
      print('invalid data');
    }
  }


}
