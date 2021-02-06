import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipic/models/user.dart';
import 'package:recipic/pages/authenticate.dart';
import 'package:recipic/pages/home.dart';
import 'package:recipic/pages/sign_in.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // return either Loading or Authenticate
    if (user == null){
      return Authenticate();
    } else {
      return SignIn();
    }
  }
}
