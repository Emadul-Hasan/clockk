import 'package:clockk/custom_component/inputfield.dart';
import 'package:clockk/models/AlertModel.dart';
import 'package:clockk/models/connectivityCheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'login.dart';

class PassRecovery extends StatefulWidget {
  static const id = "PassRecovery";
  @override
  _PassRecoveryState createState() => _PassRecoveryState();
}

class _PassRecoveryState extends State<PassRecovery> {
  bool showSpinner = false;
  _onAlertPasswordReset(context, String title) {
    Alert(
        context: context,
        title: title,
        content: Column(
          children: <Widget>[],
        ),
        buttons: [
          DialogButton(
            width: 100.0,
            color: Colors.lightBlueAccent,
            onPressed: () {
              Navigator.pushReplacementNamed(context, Login.id);
            },
            child: Text(
              "Log in",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        ]).show();
  }

  AlertMessage alert = AlertMessage();

  CheckConnectivity _connectivityCheck = CheckConnectivity();
  void checkConnection() async {
    String resultString = await _connectivityCheck.checkingConnection();
    if (resultString != null) {
      alert.messageAlert(
          context, "Error", MdiIcons.close, resultString, Colors.red);
    }
  }

  @override
  void initState() {
    checkConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String email;

    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: showSpinner,
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
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF55A1CD),
                padding: EdgeInsets.fromLTRB(85.0, 10.0, 85.0, 10.0),
              ),
              child: Text("  Reset Password  "),
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });

                var token = await FlutterSession().get('token');

                String webUrl =
                    "https://clockk.in/api/forgot_password?email=$email";
                var url = Uri.parse(webUrl);

                try {
                  http.Response response = await http.post(url, headers: {
                    'Content-type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': token
                  });

                  if (response.statusCode == 200) {
                    setState(() {
                      showSpinner = false;
                    });
                    _onAlertPasswordReset(
                        context, "Reset password request sent to your email");
                  } else {
                    setState(() {
                      showSpinner = false;
                    });
                    _onAlertPasswordReset(
                        context, "Something went wrong, Try again!");
                  }
                } catch (e) {
                }
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
      ),
    ));
  }
}
