import 'package:flutter/material.dart';
import 'package:recipic/pages/sign_in.dart';
import 'package:recipic/pages/register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignInPage = true;
  @override
  Widget build(BuildContext context) {
    if (showSignInPage){
      return SignIn();
    } else {
      return Register();
    }
  }
}