import 'package:flutter/material.dart';
import 'package:recipic/pages/sign_in.dart';
import 'package:recipic/services/auth.dart';
import 'package:recipic/models/constants.dart';

class Register extends StatefulWidget {

  Register(); // constructor for Register class

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String pageToShow = "";

  // text field state
  String email = '';
  String password = '';
  String error = '';

  void emailVerificationDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email Sent'),
          content: SingleChildScrollView(
            child: Text("We have sent you an email containing a link to "
                "verify your email address. You must verify your email "
                "address before you can sign in."),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (pageToShow) {
      case "Loading":
        return Loading();
      case "Sign In":
        return SignIn();
      default:
        return Scaffold(
          backgroundColor: Colors.grey[350],
          appBar: AppBar(
            backgroundColor: Colors.grey[700],
            elevation: 0.0,
            title: Text('Registration Page'),
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('Sign In'),
                onPressed: () {
                  setState(() {
                    pageToShow = "Sign In";
                  });
                },
              ),
            ],
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) {
                        if (val.isEmpty)
                          return 'Enter an email';
                        else
                          return null;
                      },
                      onChanged: (val) {
                        setState(() => email = val);
                      }
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val) {
                        if (val.length < 6)
                          return 'Enter a password 6+ chars long';
                        else
                          return null;
                      },
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      }
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Confirm Password'),
                      validator: (val) {
                        if (val != password)
                          return 'Passwords do not match';
                        else
                          return null;
                      },
                      obscureText: true,
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    color: Colors.grey[800],
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()){
                        setState(() => pageToShow = "Loading");
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                        if (result == null){
                          setState(() {
                            error = 'please supply a valid email';
                            pageToShow = "";
                          });
                        } else {
                          setState(() {
                            pageToShow = "Sign In";
                          });
                          emailVerificationDialog();
                        }
                      }
                    },
                  ),
                  SizedBox(height: 12),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}