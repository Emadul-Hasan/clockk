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
        body: Stack(children: [
      Positioned(
        top: 0,
        left: 0,
        child: Image.asset(
          "images/signup_top.png",
          scale: 2,
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Image.asset(
          "images/login_bottom.png",
          scale: 2,
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: Image.asset(
          "images/main_bottom.png",
          scale: 2,
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(top: 0.0),
              child: Center(
                child: Image.asset(
                  "images/logo.png",
                  width: 250.0,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Text(
                    "Welcome Back!",
                    style: TextStyle(fontSize: 25.0, color: Color(0xFF707070)),
                  ),
                )),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Inputfield(
                  obscuretext: false,
                  margin: 10.0,
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
                ),
                Container(
                  margin: EdgeInsets.only(left: 130.0),
                  child: Text(
                    "Forget Password?",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )
        ],
      )
    ]));
  }
}
