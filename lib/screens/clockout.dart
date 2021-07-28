import 'dart:async';
import 'dart:convert';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/models/AlertModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'notification.dart';

class ClockOut extends StatefulWidget {
  static const id = "ClockOut";
  @override
  _ClockOutState createState() => _ClockOutState();
}

class _ClockOutState extends State<ClockOut>
    with SingleTickerProviderStateMixin {
  var controller;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (Timer t) => timeUpdate());
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  List<String> monthString = [
    'Month',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  DateTime timeNow = DateTime.now();

  String formattedTime;

  void timeUpdate() {
    setState(() {
      timeNow = DateTime.now();
      formattedTime = "${timeNow.hour}:${timeNow.minute}:${timeNow.second}";
    });
  }

  bool showSpinner = false;
  AlertMessage alert = AlertMessage();

  @override
  Widget build(BuildContext context) {
    // int monthNumber = timeNow.month;
    // String month = monthString[monthNumber];
    // String ClockInTime = "9.00Am";
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Clock out"), () {
        Navigator.pushNamed(context, Notifications.id);
      }),
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60.0,
              ),
              Container(
                child: Text(
                  formattedTime == null
                      ? "${timeNow.hour}:${timeNow.minute}:${timeNow.second}"
                      : formattedTime,
                  style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF55A1CD)),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.only(top: 10.0),
              //   child: Text(
              //     "Clock in at $ClockInTime",
              //     style: TextStyle(color: Color(0xFF55A1CD)),
              //   ),
              // ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                width: 250.0,
                child: FutureBuilder(
                    future: FlutterSession().get('name'),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.hasData ? snapshot.data : "User name missing",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF55A1CD),
                        ),
                      );
                    }),
                alignment: Alignment.center,
              ),
              Container(
                width: 250.0,
                padding: EdgeInsets.only(top: 10.0),
                child: FutureBuilder(
                    future: FlutterSession().get('designation'),
                    builder: (context, snapshot) {
                      // print(snapshot.data);
                      return Text(
                          snapshot.hasData ? snapshot.data : "Loading...",
                          style: TextStyle(
                            color: Color(0xFF55A1CD),
                          ));
                    }),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTapDown: (_) => controller.forward(),
                  onTapUp: (_) async {
                    if (controller.status == AnimationStatus.completed) {
                      setState(() {
                        showSpinner = true;
                      });
                      var token = await FlutterSession().get('token');

                      String webUrl = "https://clockk.in/api/clock_out";
                      var url = Uri.parse(webUrl);
                      print(webUrl);

                      try {
                        http.Response response = await http.post(url, headers: {
                          'Content-type': 'application/json',
                          'Accept': 'application/json',
                          'Authorization': token
                        });
                        var body = jsonDecode(response.body);

                        if (response.statusCode == 200) {
                          setState(() {
                            showSpinner = false;
                          });
                          String message = body['message'];
                          alert.messageAlert(context, "Status", MdiIcons.check,
                              message.toString(), Colors.green);
                        } else if (response.statusCode == 404) {
                          setState(() {
                            showSpinner = false;
                          });
                          String message = body['data']['error'];

                          alert.messageAlert(context, "Status", MdiIcons.alert,
                              message.toString(), Colors.orange);
                        } else {
                          setState(() {
                            showSpinner = false;
                          });
                          alert.messageAlert(
                              context,
                              "Status",
                              MdiIcons.alert,
                              'Keep active your location and internet service',
                              Colors.orange);

                          print(response.body);
                        }
                      } catch (e) {
                        print(e);
                      }
                      controller.value = 0.0;
                    }
                    if (controller.status == AnimationStatus.forward) {
                      controller.reverse();
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: CircularProgressIndicator(
                          semanticsLabel: 'Tap here',
                          strokeWidth: 6.0,
                          value: controller.value,
                          backgroundColor: Color(0xFF55A1CD),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                        ),
                      ),
                      Icon(
                        MdiIcons.clockFast,
                        color: Color(0xFF55A1CD),
                        size: 35.0,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
