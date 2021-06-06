import 'package:clockk/custom_component/inputfield.dart';
import 'package:clockk/screens/dashboard.dart';
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
        children: [
          Container(
            padding: EdgeInsets.only(top: 120.0),
            child: Center(
              child: Image.asset(
                "images/logo.png",
                width: 350.0,
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 30.0),
              child: Center(
                child: Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 25.0, color: Color(0xFF707070)),
                ),
              )),
          Inputfield(
            obscuretext: false,
            margin: 25.0,
            hintText: 'Enter Your Email',
            keyBoardtype: TextInputType.emailAddress,
            prefixicon: Icon(Icons.mail),
            function: (value) {
              print(value);
            },
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
                padding: EdgeInsets.fromLTRB(110.0, 10.0, 110.0, 10.0),
              ),
              child: Text("Login"),
              onPressed: () {
                Navigator.pushReplacementNamed(context, DashBoard.id);
              },
            ),
          )
        ],
      ),
    );
  }
}
