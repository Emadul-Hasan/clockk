import 'dart:async';
import 'dart:convert';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/models/AlertModel.dart';
import 'package:clockk/models/connectivityCheck.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'notification.dart';

class ClockIn extends StatefulWidget {
  static const id = "ClockIn";
  @override
  _ClockInState createState() => _ClockInState();
}

class _ClockInState extends State<ClockIn> with SingleTickerProviderStateMixin {
  var controller;

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
    getCurrentLocation();
    Timer.periodic(Duration(seconds: 1), (Timer t) => timeUpdate());
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  double latitube;
  double longitude;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitube = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      alert.messageAlert(context, 'title', MdiIcons.alert,
          'Turn on your location and refresh this page', Colors.orange);
    }
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
  AlertMessage alert = AlertMessage();

  void timeUpdate() {
    setState(() {
      timeNow = DateTime.now();

      formattedTime =
          "${timeNow.hour.toString().padLeft(2, '0')}:${timeNow.minute.toString().padLeft(2, '0')}:${timeNow.second.toString().padLeft(2, '0')}";
    });
  }

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    int monthNumber = timeNow.month;
    String month = monthString[monthNumber];

    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Clock in"), () {
        Navigator.pushNamed(context, Notifications.id);
      }),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
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
                        ? "${timeNow.hour.toString().padLeft(2, '0')}:${timeNow.minute.toString().padLeft(2, '0')}:${timeNow.second.toString().padLeft(2, '0')}"
                        : formattedTime,
                    style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF55A1CD)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "$month ${timeNow.day},${timeNow.year}",
                    style: TextStyle(color: Color(0xFF55A1CD)),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  width: 250.0,
                  child: FutureBuilder(
                      future: FlutterSession().get('name'),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.hasData
                              ? snapshot.data
                              : "User name missing",
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
                  // padding: EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    onTapDown: (_) => controller.forward(),
                    onTapUp: (_) async {
                      if (controller.status == AnimationStatus.completed) {
                        setState(() {
                          showSpinner = true;
                        });
                        var token = await FlutterSession().get('token');
                        String webUrl =
                            "https://clockk.in/api/clock_in?lat=$latitube&long=$longitude";
                        var url = Uri.parse(webUrl);

                        try {
                          http.Response response =
                              await http.post(url, headers: {
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
                            alert.messageAlert(
                                context,
                                "Status",
                                MdiIcons.check,
                                message.toString(),
                                Colors.green);
                          } else if (response.statusCode == 404) {
                            setState(() {
                              showSpinner = false;
                            });
                            String message = body['data']['error'];
                            alert.messageAlert(
                                context,
                                "Status",
                                MdiIcons.alert,
                                message.toString(),
                                Colors.orange);
                          } else {
                            setState(() {
                              showSpinner = false;
                            });
                            alert.messageAlert(
                                context,
                                "Status",
                                MdiIcons.close,
                                "Check your internet service",
                                Colors.red);
                          }
                        } catch (e) {
                          alert.messageAlert(context, "Error", MdiIcons.close,
                              'Something went wrong', Colors.red);
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
                          height: 120,
                          width: 120,
                          child: CircularProgressIndicator(
                            semanticsLabel: 'Tap here',
                            strokeWidth: 8.0,
                            value: controller.value,
                            backgroundColor: Color(0xFF55A1CD),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                          ),
                        ),
                        Text("Tap & Hold",
                            style: TextStyle(
                                color: Color(0xFF55A1CD),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                        // Icon(
                        //   MdiIcons.clockCheckOutline,
                        //   color: Color(0xFF55A1CD),
                        //   size: 35.0,
                        // )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
