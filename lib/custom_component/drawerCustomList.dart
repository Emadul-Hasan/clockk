import 'package:clockk/screens/clockin.dart';
import 'package:clockk/screens/clockout.dart';
import 'package:clockk/screens/dashboard.dart';
import 'package:clockk/screens/login.dart';
import 'package:clockk/screens/mychecklist.dart';
import 'package:clockk/screens/profile.dart';
import 'package:clockk/screens/rota.dart';
import 'package:clockk/screens/teamchecklist.dart';
import 'package:clockk/screens/timesheet.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DrawerCustomList extends StatelessWidget {
  const DrawerCustomList({
    Key key,
  }) : super(key: key);

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
                  CircleAvatar(
                    radius: 28.0,
                    backgroundImage: AssetImage('images/prof.png'),
                    // child: Image(
                    //   image: AssetImage('images/prof.png'),
                    // ),
                  ),
                  SizedBox(
                    width: 10.0,
                    height: double.infinity,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User Name"),
                      Text("user@gmail.com"),
                    ],
                  )
                ],
              ),
            ),
            CustomListTile(
              menuTitle: 'Dashboard',
              icon: MdiIcons.dotsGrid,
              action: () {
                Navigator.pushReplacementNamed(context, DashBoard.id);
              },
            ),
            CustomListTile(
                menuTitle: 'Clock in',
                icon: MdiIcons.clockCheckOutline,
                action: () {
                  Navigator.pushReplacementNamed(context, ClockIn.id);
                }),
            CustomListTile(
                menuTitle: 'Clock out',
                icon: MdiIcons.clockFast,
                action: () {
                  Navigator.pushReplacementNamed(context, ClockOut.id);
                }),
            CustomListTile(
                menuTitle: 'My Task List',
                icon: MdiIcons.formatListChecks,
                action: () {
                  Navigator.pushReplacementNamed(context, MyCheckList.id);
                }),
            CustomListTile(
                menuTitle: 'Team Task List',
                icon: MdiIcons.formatListCheckbox,
                action: () {
                  Navigator.pushReplacementNamed(context, TeamCheckList.id);
                }),
            CustomListTile(
                menuTitle: 'Rota',
                icon: MdiIcons.calendarClockOutline,
                action: () {
                  Navigator.pushReplacementNamed(context, Rota.id);
                }),
            CustomListTile(
                menuTitle: 'Profile',
                icon: MdiIcons.accountOutline,
                action: () {
                  Navigator.pushReplacementNamed(context, ProfileScreen.id);
                }),
            CustomListTile(
                menuTitle: 'Time sheet',
                icon: MdiIcons.calendarOutline,
                action: () {
                  Navigator.pushReplacementNamed(context, TimeSheet.id);
                }),
            CustomListTile(
                menuTitle: 'Logout',
                icon: MdiIcons.logout,
                action: () {
                  Navigator.pushReplacementNamed(context, Login.id);
                }),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String menuTitle;
  final IconData icon;
  final Function action;
  CustomListTile(
      {@required this.menuTitle, @required this.icon, @required this.action});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        menuTitle,
        style: TextStyle(
            color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w400),
      ),
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black12, spreadRadius: 2)
          ],
        ),
        child: CircleAvatar(
          child: Icon(
            icon,
            color: Colors.black,
            size: 25.0,
          ),
          backgroundColor: Colors.white,
        ),
      ),
      onTap: action,
    );
  }
}
