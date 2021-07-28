import 'dart:convert';
import 'dart:io' show Platform, exit;

import 'package:clockk/custom_component/inputfield.dart';
import 'package:clockk/screens/dashboard.dart';
import 'package:clockk/screens/passrecoverypage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Login extends StatefulWidget {
  static const id = "Login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;
  bool showSpiner = false;

  _onFaildToLogin(context) {
    Alert(
        context: context,
        title: "Failed to login",
        closeIcon: Icon(MdiIcons.close),
        content: Center(
          child: Text(
            "User id or password don't matched",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Try Again",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]).show();
  }

  _onFaildToLoginInternet(context) {
    Alert(
        context: context,
        title: "Failed to login",
        closeIcon: Icon(MdiIcons.close),
        content: Center(
          child: Text(
            "Check your connectivity",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Try Again",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]).show();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Confirm'),
              content: Text('Do you want to exit the App'),
              actions: <Widget>[
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false); //Will not exit the App
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else {
                      exit(0);
                    }
                    // Navigator.of(context).pop(true); //Will exit the App
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          body: ModalProgressHUD(
        inAsyncCall: showSpiner,
        child: Column(
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
                  email = value;
                },
              ),
            ),
            Inputfield(
              obscuretext: true,
              margin: 10.0,
              hintText: 'Enter Your Password',
              prefixicon: Icon(Icons.lock),
              function: (value) {
                password = value;
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
                onPressed: () async {
                  String webUrl =
                      "https://clockk.in/api/login?email=$email&password=$password";
                  var url = Uri.parse(webUrl);
                  print(webUrl);
                  setState(() {
                    showSpiner = true;
                  });
                  try {
                    http.Response response = await http.post(url);

                    if (response.statusCode == 200) {
                      var data = jsonDecode(response.body);
                      print(data);
                      var token = data['data'];
                      await FlutterSession().set("token", token['token']);
                      await FlutterSession().set('name', token['name']);
                      await FlutterSession().set('email', token['email']);
                      await FlutterSession().set('image', token['picture']);
                      await FlutterSession()
                          .set('designation', token['designation']);
                      await FlutterSession()
                          .set('company_name', token['company_name']);

                      setState(() {
                        showSpiner = false;
                      });
                      Navigator.pushReplacementNamed(context, DashBoard.id);
                    } else {
                      setState(() {
                        showSpiner = false;
                      });

                      _onFaildToLogin(context);
                      print(response.statusCode);
                    }
                  } catch (e) {
                    setState(() {
                      showSpiner = false;
                    });
                    _onFaildToLoginInternet(context);

                    print("Error Caught");
                    print(e);
                  }
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
        ),
      )),
    );
  }
}
