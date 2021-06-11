import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ClockOut extends StatefulWidget {
  static const id = "ClockOut";
  @override
  _ClockOutState createState() => _ClockOutState();
}

class _ClockOutState extends State<ClockOut> {
  // List<String> DropDownItems = ["Azhar", "Beauty", "Mujib"];
  // String valueChoosen;
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (Timer t) => timeUpdate());
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

  @override
  Widget build(BuildContext context) {
    int monthNumber = timeNow.month;
    String month = monthString[monthNumber];
    String ClockInTime = "9.00Am";
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Clock out")),
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
                  "Clock in at $ClockInTime",
                  style: TextStyle(color: Color(0xFF55A1CD)),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                width: 250.0,
                child: Text(
                  "Nur Karim",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    // color: Color(0xFF55A1CD),
                  ),
                ),
                alignment: Alignment.center,
              ),
              Container(
                width: 250.0,
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Manager",
                  style: TextStyle(color: Color(0xFF55A1CD)),
                ),
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
                  child: Text("Clock out"),
                  onPressed: () {
                    print("Pressed");
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
