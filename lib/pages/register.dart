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
          title: Text('Registration Page'),
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
                    onChanged: (val){
                      setState(() => email = val);
                    }
                ),
                SizedBox(height: 20),
                TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => password = val);
                    }
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
                      setState(() => showLoadingPage = true);
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                      if(result == null){
                        setState(() {
                          error = 'please supply a valid email';
                          showLoadingPage = false;
                        });
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