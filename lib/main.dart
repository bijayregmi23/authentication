import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'SignInPage.dart';
import 'SignUpPage.dart';
import 'ForgotPassword.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Authentication',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomePage(),
      routes: <String,WidgetBuilder>{
        "/SignInPage":(BuildContext context) => SignInPage(),
        "/SignUpPage":(BuildContext context) => SignUpPage(),
        "/HomePage":(BuildContext context) => HomePage(),
        "/ForgotPassword":(BuildContext context) => ForgotPassword(),
      },
    );
  }
}