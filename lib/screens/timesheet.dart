import 'dart:convert';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'notification.dart';

class TimeSheet extends StatefulWidget {
  static const id = "TimeSheet";
  @override
  _TimeSheetState createState() => _TimeSheetState();
}

class _TimeSheetState extends State<TimeSheet> {
  Future<void> getTimeSheetData() async {
    UserEntryRecord.clear();
    setState(() {
      showSpinner = true;
    });
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/timesheet";
    var url = Uri.parse(webUrl);
    print(webUrl);
    try {
      http.Response response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        var value = data['data'];
        print(value);
        for (var item in value) {
          print(item);
          setState(() {
            UserEntryRecord.add(UserEntryModel(
                item['date'].toString() == "null"
                    ? '--'
                    : item['date'].toString(),
                item['in_time'].toString() == "null"
                    ? '--'
                    : item['in_time'].toString(),
                item['out_time'].toString() == "null"
                    ? '--'
                    : item['out_time'].toString(),
                item['total_hour'].toString() == "null"
                    ? '--'
                    : item['total_hour'].toString()));
            showSpinner = false;
          });
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  List<UserEntryModel> UserEntryRecord = [];

  @override
  void initState() {
    getTimeSheetData();
    super.initState();
  }

  List monthString = [
    // 'Month',
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
  List yearString = [
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
  ];

  bool showSpinner = true;
  String monthChoosen;
  String yearChoosen;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: getTimeSheetData,
        child: Icon(MdiIcons.refresh),
      ),
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Time Sheet"), () {
        Navigator.pushNamed(context, Notifications.id);
      }),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Container(
                      height: 40.0,
                      margin: EdgeInsets.only(top: 5.0, right: 3.0),
                      padding: EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        underline: SizedBox(),
                        dropdownColor: Colors.white,
                        value: monthChoosen,
                        onChanged: (value) {
                          setState(() {
                            monthChoosen = value;
                          });
                        },
                        hint: Text('Select Month'),
                        items: monthString.map(
                          (valueItem) {
                            return DropdownMenuItem(
                                value: valueItem, child: Text(valueItem));
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40.0,
                      margin: EdgeInsets.only(top: 5.0),
                      padding: EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        underline: SizedBox(),
                        dropdownColor: Colors.white,
                        value: yearChoosen,
                        onChanged: (value) {
                          setState(() {
                            yearChoosen = value;
                          });
                        },
                        hint: Text('Select year'),
                        items: yearString.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 1.0, right: 1.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            print(monthChoosen);
                            print(yearChoosen);
                          });
                        },
                        child: Text('Get Time Sheet'),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 1.0, right: 1.0),
                          child: ElevatedButton(
                              onPressed: () {}, child: Text('Reset')))),
                  SizedBox(
                    width: 20.0,
                  ),
                ],
              ),
              DataTable(
                columnSpacing: 20.0,
                horizontalMargin: 20.0,
                columns: <DataColumn>[
                  DataColumn(label: Text("Date")),
                  DataColumn(label: Text("Clock in")),
                  DataColumn(label: Text("Clock Out")),
                  DataColumn(label: Text("Total Hour")),
                ],
                rows: UserEntryRecord.map(
                  (User) => DataRow(
                    cells: [
                      DataCell(
                        Center(child: Text(User.UserName)),
                      ),
                      DataCell(Center(child: Text(User.EnterTime))),
                      DataCell(Center(child: Text(User.ExitTime))),
                      DataCell(Center(
                          child: Text(
                        User.TotalHour,
                      ))),
                    ],
                  ),
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserEntryModel {
  final String UserName;
  final String EnterTime;
  final String ExitTime;
  final String TotalHour;
  UserEntryModel(this.UserName, this.EnterTime, this.ExitTime, this.TotalHour);
}
