import 'dart:async';

import 'package:clockk/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 5), () async {
      dynamic token = await FlutterSession().get('token');
      if (token == null || token == '') {
        print(token);
        Navigator.pushReplacementNamed(context, Login.id);
      } else {
        Navigator.pushReplacementNamed(context, DashBoard.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage(
            'images/logo.gif',
          ),
          width: 200.0,
        ),
      ),
    );
  }
}
