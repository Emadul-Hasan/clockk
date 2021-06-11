import 'dart:async';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/custom_component/inputfield.dart';
import 'package:clockk/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ClockIn extends StatefulWidget {
  static const id = "ClockIn";
  @override
  _ClockInState createState() => _ClockInState();
}

class _ClockInState extends State<ClockIn> {
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
                  child: Text("Clock in"),
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
// DropdownSearch(
//                   dropdownSearchDecoration: InputDecoration(
//                     contentPadding: EdgeInsets.only(
//                         left: 5.0, right: 0.0, top: 0.0, bottom: 0.0),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(0.0),
//                       ),
//                     ),
//                     enabledBorder: KoutlineInputBorderDrop,
//                     focusedBorder: KoutlineInputBorderDrop,
//                   ),
//
//                   hint: "User Name",
//                   mode: Mode.DIALOG,
//                   showSearchBox: true,
//                   selectedItem: valueChoosen,
//                   showClearButton: true,
//                   showAsSuffixIcons: false,
//
//                   onChanged: (value) {
//                     setState(() {
//                       valueChoosen = value;
//                     });
//                   },
//                   items: DropDownItems,
//
// ////////////////////////////////////////////////
//                   // underline: SizedBox(),
//                   // icon: Icon(Icons.arrow_drop_down),
//                   // iconSize: 30.0,
//                   // isExpanded: true,
//                   // style: TextStyle(
//                   //   color: Colors.black,
//                   //   fontSize: 16.0,
//                   // ),
//                   // hint: Text("User Name"),
//                   // value: valueChoosen,
//                   // onChanged: (newvalue) {
//                   //   setState(() {
//                   //     valueChoosen = newvalue;
//                   //     print(newvalue);
//                   //   });
//                   // },
//                   // items: DropDownItems.map((valueItem) {
//                   //   return DropdownMenuItem(
//                   //     value: valueItem,
//                   //     child: Text(valueItem),
//                   //   );
//                   // }).toList(),
//                 )
