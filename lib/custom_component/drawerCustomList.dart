import 'package:clockk/models/AlertModel.dart';
import 'package:clockk/screens/clockin.dart';
import 'package:clockk/screens/clockout.dart';
import 'package:clockk/screens/dashboard.dart';
import 'package:clockk/screens/login.dart';
import 'package:clockk/screens/morefeature.dart';
import 'package:clockk/screens/myremainingtaskTitle.dart';
import 'package:clockk/screens/profile.dart';
import 'package:clockk/screens/rota.dart';
import 'package:clockk/screens/teamremainingtaskTitle.dart';
import 'package:clockk/screens/timesheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'CustomTile.dart';

class DrawerCustomList extends StatefulWidget {
  const DrawerCustomList({
    Key key,
  }) : super(key: key);

  @override
  _DrawerCustomListState createState() => _DrawerCustomListState();
}

class _DrawerCustomListState extends State<DrawerCustomList> {
  AlertMessage alert = AlertMessage();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  FutureBuilder(
                      future: FlutterSession().get('image'),
                      builder: (context, snapshot) {
                        // print(snapshot.data);
                        return CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 28.0,
                          backgroundImage: snapshot.hasData
                              ? NetworkImage(snapshot.data)
                              : AssetImage('images/logo.png'),
                          // child: Image(
                          //   image: AssetImage('images/prof.png'),
                          // ),
                        );
                      }),
                  SizedBox(
                    width: 10.0,
                    height: double.infinity,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                          future: FlutterSession().get('name'),
                          builder: (context, snapshot) {
                            // print(snapshot.data);
                            return Text(snapshot.hasData
                                ? snapshot.data
                                : "User name missing");
                          }),
                      FutureBuilder(
                          future: FlutterSession().get('company_name'),
                          builder: (context, snapshot) {
                            // print(snapshot.data);
                            return Text(snapshot.hasData
                                ? snapshot.data
                                : "User name missing");
                          }),
                    ],
                  )
                ],
              ),
            ),
            CustomListTile(
              menuTitle: 'Dashboard',
              icon: MdiIcons.dotsGrid,
              action: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, DashBoard.id);
              },
            ),
            CustomListTile(
                menuTitle: 'Clock In',
                icon: MdiIcons.clockCheckOutline,
                action: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, ClockIn.id);
                }),
            CustomListTile(
                menuTitle: 'Clock Out',
                icon: MdiIcons.clockFast,
                action: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, ClockOut.id);
                }),
            CustomListTile(
                menuTitle: 'My Checklist',
                icon: MdiIcons.formatListChecks,
                action: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, MyRemainingTaskTitle.id);
                }),
            CustomListTile(
                menuTitle: 'Team Checklist',
                icon: MdiIcons.formatListCheckbox,
                action: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, TeamRemainingTaskTitle.id);
                }),
            CustomListTile(
                menuTitle: 'Rota',
                icon: MdiIcons.calendarClockOutline,
                action: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, Rota.id);
                }),
            CustomListTile(
                menuTitle: 'Profile',
                icon: MdiIcons.accountOutline,
                action: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, ProfileScreen.id);
                }),
            CustomListTile(
                menuTitle: 'Time Sheet',
                icon: MdiIcons.calendarOutline,
                action: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, TimeSheet.id);
                }),
            CustomListTile(
                menuTitle: 'More Features',
                icon: MdiIcons.web,
                action: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, MoreFeatures.id);
                }),
            CustomListTile(
                menuTitle: 'Logout',
                icon: MdiIcons.logout,
                action: () async {
                  var token = await FlutterSession().get('token');
                  String webUrl = "https://clockk.in/api/logout";
                  var url = Uri.parse(webUrl);
                  print(url);
                  try {
                    http.Response response = await http.get(url, headers: {
                      'Content-type': 'application/json',
                      'Accept': 'application/json',
                      'Authorization': token
                    });

                    if (response.statusCode == 200) {
                      print('Done');
                      await FlutterSession().set('token', '');
                      Navigator.pushReplacementNamed(context, Login.id);
                    } else {
                      print(response.statusCode);
                    }
                  } catch (e) {
                    print(e);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
