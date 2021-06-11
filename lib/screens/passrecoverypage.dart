import 'package:clockk/custom_component/inputfield.dart';
import 'package:clockk/screens/dashboard.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class PassRecovery extends StatefulWidget {
  static const id = "PassRecovery";
  @override
  _PassRecoveryState createState() => _PassRecoveryState();
}

class _PassRecoveryState extends State<PassRecovery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Center(
            child: Image.asset(
              "images/logo.png",
              width: 250.0,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Inputfield(
            obscuretext: false,
            margin: 10.0,
            hintText: 'Enter Your Email',
            keyBoardtype: TextInputType.emailAddress,
            prefixicon: Icon(Icons.mail),
            function: (value) {
              print(value);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF55A1CD),
              padding: EdgeInsets.fromLTRB(85.0, 10.0, 85.0, 10.0),
            ),
            child: Text("Reset Password..."),
            onPressed: () {
              Navigator.pushReplacementNamed(context, DashBoard.id);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 150.0),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, Login.id);
            },
            child: Text(
              "Remember Password?",
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    ));
  }
}
