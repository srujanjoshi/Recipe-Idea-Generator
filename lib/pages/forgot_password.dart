import 'package:flutter/material.dart';
import 'package:recipic/services/auth.dart';
import 'package:recipic/models/constants.dart';
import 'package:recipic/pages/sign_in.dart';
import 'dart:developer';

class ForgotPassword extends StatefulWidget {

  final Function toggleView;
  ForgotPassword({this.toggleView}); // constructor for ForgotPassword class

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool showLoadingPage = false;
  bool showSignInPage = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    if (showLoadingPage && !showSignInPage) {
      return Loading();
    }
    else if (!showLoadingPage && showSignInPage) {
      return SignIn();
    }
    else {
      return Scaffold(
        backgroundColor: Colors.grey[350],
        appBar: AppBar(
          backgroundColor: Colors.grey[700],
          elevation: 0.0,
          title: Text('Forgot Password'),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign In'),
              onPressed: () {
                setState(() {
                  showLoadingPage = false;
                  showSignInPage = true;
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
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    }
                ),
                SizedBox(height: 20),
                RaisedButton(
                  color: Colors.grey[800],
                  child: Text(
                    'Send Password Reset Link',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      try {
                        dynamic result = await _auth.sendPasswordResetEmail(email);
                      } catch (e) {
                        // Show the exception in a dialog box
                        log(e.toString());
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: SingleChildScrollView(
                                child: Text(e.toString()),
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