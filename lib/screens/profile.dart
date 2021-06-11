import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/custom_component/inputfield.dart';
import 'package:clockk/screens/timesheet.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'dashboard.dart';
import 'login.dart';

class ProfileScreen extends StatelessWidget {
  static String id = "ProfileScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Profile")),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  _onAlertPasswordChange(context) {
    Alert(
        context: context,
        title: "Change Password",
        content: Column(
          children: <Widget>[
            Inputfield(
              obscuretext: true,
              margin: 10.0,
              hintText: 'Enter old password',
              prefixicon: Icon(Icons.lock),
              function: (value) {
                print(value);
              },
            ),
            Inputfield(
              obscuretext: true,
              margin: 10.0,
              hintText: 'Enter new password',
              prefixicon: Icon(Icons.lock),
              function: (value) {
                print(value);
              },
            ),
            Inputfield(
              obscuretext: true,
              margin: 10.0,
              hintText: 'Confirm new password',
              prefixicon: Icon(Icons.lock),
              function: (value) {
                print(value);
              },
            ),
          ],
        ),
        buttons: [
          DialogButton(
            width: 100.0,
            color: Colors.lightBlueAccent,
            onPressed: () {
              print("pressed");
              Navigator.pop(context);
            },
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        ]).show();
  }

  _onAlertProfileChange(context) {
    Alert(
        context: context,
        title: "Change Profile",
        content: Column(
          children: <Widget>[
            Inputfield(
              obscuretext: true,
              margin: 10.0,
              hintText: 'Your Name',
              prefixicon: Icon(MdiIcons.accountOutline),
              function: (value) {
                print(value);
              },
            ),
            Inputfield(
              obscuretext: true,
              margin: 10.0,
              hintText: 'Your phone number',
              prefixicon: Icon(MdiIcons.phoneOutline),
              function: (value) {
                print(value);
              },
            ),
            Inputfield(
              obscuretext: true,
              margin: 10.0,
              hintText: 'Email',
              prefixicon: Icon(MdiIcons.emailOutline),
              function: (value) {
                print(value);
              },
            ),
            Inputfield(
              obscuretext: true,
              margin: 10.0,
              hintText: 'Adress',
              prefixicon: Icon(MdiIcons.mapMarkerOutline),
              function: (value) {
                print(value);
              },
            ),
          ],
        ),
        buttons: [
          DialogButton(
            width: 100.0,
            color: Colors.lightBlueAccent,
            onPressed: () {
              print("pressed");
              Navigator.pop(context);
            },
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
              text: "Dashboard",
              icon: MdiIcons.dotsGrid,
              press: () {
                Navigator.pushNamed(context, DashBoard.id);
              }),
          ProfileMenu(
            text: "Time sheet",
            icon: MdiIcons.calendarOutline,
            press: () {
              Navigator.pushNamed(context, TimeSheet.id);
            },
          ),
          ProfileMenu(
            text: "Change password",
            icon: MdiIcons.onepassword,
            icon2: Icons.edit,
            press: () {
              _onAlertPasswordChange(context);
            },
          ),
          ProfileMenu(
            text: "Change profile",
            icon: MdiIcons.accountOutline,
            icon2: Icons.edit,
            press: () {
              _onAlertProfileChange(context);
            },
          ),
          ProfileMenu(
            text: "Log Out",
            icon: MdiIcons.logout,
            press: () {
              Navigator.pushNamed(context, Login.id);
            },
          ),
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu(
      {Key key,
      @required this.text,
      @required this.icon,
      this.press,
      this.icon2})
      : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback press;
  final IconData icon2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(icon2),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("images/prof.png"),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 50,
              width: 50,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {},
                child: Icon(
                  MdiIcons.camera,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
