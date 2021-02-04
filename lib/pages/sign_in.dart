import 'package:flutter/material.dart';
import 'package:recipic/pages/forgot_password.dart';
import 'package:recipic/pages/register.dart';
import 'package:recipic/services/auth.dart';
import 'package:recipic/models/constants.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView}); // constructor for SignIn class

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool showForgotPassword = false;
  bool showRegisterPage = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    if (loading && !showForgotPassword && !showRegisterPage) {
      return Loading();
    }
    else if (!loading && showForgotPassword && !showRegisterPage) {
      return ForgotPassword();
    }
    else if (!loading && !showForgotPassword && showRegisterPage) {
      return Register();
    }
    else {
      return Scaffold(
        backgroundColor: Colors.grey[350],
        appBar: AppBar(
          backgroundColor: Colors.grey[700],
          elevation: 0.0,
          title: Text('Sign In Page'),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Register'),
              onPressed: () {
                setState(() {
                  loading = false;
                  showForgotPassword = false;
                  showRegisterPage = true;
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
                TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Password'),
                    validator: (val) =>
                    val.length < 6
                        ? 'Enter a password 6+ chars long'
                        : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => password = val);
                    }
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Colors.grey[800],
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error =
                              'could not sign in with those credentials';
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(width: 10),
                    RaisedButton(
                        child: Text(
                            "Forgot Password",
                            style: TextStyle(color: Colors.white)
                        ),
                        color: Colors.grey[800],
                        onPressed: () {
                          setState(() {
                            loading = false;
                            showForgotPassword = true;
                            showRegisterPage = false;
                          });
                        }
                    )
                  ],
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