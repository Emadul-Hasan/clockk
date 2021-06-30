import 'package:clockk/screens/clockout.dart';
import 'package:clockk/screens/mychecklist.dart';
import 'package:clockk/screens/passrecoverypage.dart';
import 'package:clockk/screens/profile.dart';
import 'package:clockk/screens/rota.dart';
import 'package:clockk/screens/teamchecklist.dart';
import 'package:clockk/screens/test.dart';
import 'package:clockk/screens/timesheet.dart';
import 'package:flutter_session/flutter_session.dart';
import 'screens/dashboard.dart';
import 'screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/clockin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        Login.id: (context) => Login(),
        ClockIn.id: (context) => ClockIn(),
        ClockOut.id: (context) => ClockOut(),
        DashBoard.id: (context) => DashBoard(),
        MyCheckList.id: (context) => MyCheckList(),
        TeamCheckList.id: (context) => TeamCheckList(),
        Rota.id: (context) => Rota(),
        TimeSheet.id: (context) => TimeSheet(),
        ProfileScreen.id: (context) => ProfileScreen(),
        PassRecovery.id: (context) => PassRecovery(),
      },
    );
  }
}
