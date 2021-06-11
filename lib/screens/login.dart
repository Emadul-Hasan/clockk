import 'package:clockk/custom_component/inputfield.dart';
import 'package:clockk/screens/dashboard.dart';
import 'package:clockk/screens/passrecoverypage.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static const id = "Login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
        Inputfield(
          obscuretext: true,
          margin: 10.0,
          hintText: 'Enter Your Password',
          prefixicon: Icon(Icons.lock),
          function: (value) {
            print(value);
          },
        ),
        Container(
          padding: EdgeInsets.only(top: 10.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF55A1CD),
              padding: EdgeInsets.fromLTRB(120.0, 10.0, 120.0, 10.0),
            ),
            child: Text("Login"),
            onPressed: () {
              Navigator.pushReplacementNamed(context, DashBoard.id);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 150.0),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, PassRecovery.id);
            },
            child: Text(
              "Forget Password?",
            ),
          ),
        )
      ],
    ));
  }
}
