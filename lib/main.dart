import 'package:clockk/screens/clockout.dart';
import 'package:clockk/screens/morefeature.dart';
import 'package:clockk/screens/myremainingtaskTitle.dart';
import 'package:clockk/screens/mysubtask.dart';
import 'package:clockk/screens/notification.dart';
import 'package:clockk/screens/passrecoverypage.dart';
import 'package:clockk/screens/profile.dart';
import 'package:clockk/screens/rota.dart';
import 'package:clockk/screens/teamremainingtaskTitle.dart';
import 'package:clockk/screens/teamsubtask.dart';
import 'package:clockk/screens/timesheet.dart';
import 'package:flutter/material.dart';

import 'screens/clockin.dart';
import 'screens/dashboard.dart';
import 'screens/login.dart';
import 'screens/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clockk.in',
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
        MyRemainingTaskTitle.id: (context) => MyRemainingTaskTitle(),
        TeamRemainingTaskTitle.id: (context) => TeamRemainingTaskTitle(),
        RemainingSubTask.id: (context) => RemainingSubTask(),
        TeamRemainingSubTask.id: (context) => TeamRemainingSubTask(),
        Rota.id: (context) => Rota(),
        TimeSheet.id: (context) => TimeSheet(),
        ProfileScreen.id: (context) => ProfileScreen(),
        MoreFeatures.id: (context) => MoreFeatures(),
        PassRecovery.id: (context) => PassRecovery(),
        Notifications.id: (context) => Notifications(),
      },
    );
  }
}
