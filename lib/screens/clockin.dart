import 'dart:async';
import 'dart:convert';
import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ClockIn extends StatefulWidget {
  static const id = "ClockIn";
  @override
  _ClockInState createState() => _ClockInState();
}

class _ClockInState extends State<ClockIn> {
  @override
  void initState() {
    getcurrentlocation();
    Timer.periodic(Duration(seconds: 1), (Timer t) => timeUpdate());
    super.initState();
  }

  double latitube;
  double longitude;

  Future<void> getcurrentlocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitube = position.latitude;
      longitude = position.longitude;
      print(latitube);
      print(longitude);
    } catch (e) {
      print(e);
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

  void timeUpdate() {
    setState(() {
      timeNow = DateTime.now();
      formattedTime = "${timeNow.hour}:${timeNow.minute}:${timeNow.second}";
    });
  }

  _onSuccessToClockin(context) {
    Alert(
        context: context,
        title: "Success",
        closeIcon: Icon(MdiIcons.close),
        content: Center(
          child: Text(
            "Clocked in",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Done",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    int monthNumber = timeNow.month;
    String month = monthString[monthNumber];

    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Clock in")),
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
                      // print(snapshot.data);
                      return Text(
                        snapshot.hasData ? snapshot.data : "User name missing",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          // color: Color(0xFF55A1CD),
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF55A1CD),
                    padding: EdgeInsets.fromLTRB(100.0, 10.0, 100.0, 10.0),
                  ),
                  child: Text("Clock in"),
                  onPressed: () async {
                    var token = await FlutterSession().get('token');
                    print(token);

                    String webUrl =
                        "https://clockk.in/api/clock_in?lat=$latitube&long=$longitude";
                    var url = Uri.parse(webUrl);
                    print(webUrl);

                    try {
                      http.Response response = await http.post(url, headers: {
                        'Content-type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization': token
                      });

                      if (response.statusCode == 200) {
                        print("Clocked in");
                        _onSuccessToClockin(context);
                      } else {
                        print(response.statusCode);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
