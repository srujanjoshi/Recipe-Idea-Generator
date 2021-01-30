import 'package:flutter/material.dart';
import 'package:recipic/services/auth.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text("Home Page"),
          SizedBox(height: 100),
          FlatButton.icon(
            icon: Icon(Icons.person),
            color: Colors.white,
            label: Text('Sign Out'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ]
      )
    );
  }
}
