import 'dart:convert';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/models/AlertModel.dart';
import 'package:clockk/models/connectivityCheck.dart';
import 'package:clockk/models/userEntryModel.dart';
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
  List monthString = [
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
  int flag = 0;
  List<UserEntryModel> userEntryRecord = [];

  Future<void> getTimeSheetData() async {
    userEntryRecord.clear();
    monthChoosen = null;
    yearChoosen = null;
    setState(() {
      showSpinner = true;
    });
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/timesheet";
    var url = Uri.parse(webUrl);
    try {
      http.Response response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var value = data['data'];
        for (var item in value) {
          flag = 0;
          setState(() {
            showSpinner = false;
            userEntryRecord.add(UserEntryModel(
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
          });
        }
      } else {
        alert.messageAlert(context, "Error", MdiIcons.close,
            'Something went wrong', Colors.red);
      }
    } catch (e) {
      alert.messageAlert(
          context, "Error", MdiIcons.close, 'Something went wrong', Colors.red);
    }
  }

  Future<void> getShortedTimeSheetData(String month, String year) async {
    userEntryRecord.clear();
    setState(() {
      showSpinner = true;
    });
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/timesheet?month=$month&year=$year";
    var url = Uri.parse(webUrl);
    try {
      http.Response response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        var value = data['data'];
        if (value?.isEmpty ?? true) {
          flag = 1;
          setState(() {
            showSpinner = false;
          });
        } else {
          flag = 0;
        }
        for (var item in value) {
          setState(() {
            showSpinner = false;
            userEntryRecord.add(UserEntryModel(
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
          });
        }
      } else {
        alert.messageAlert(context, "Error", MdiIcons.close,
            'Something went wrong', Colors.red);
      }
    } catch (e) {
      alert.messageAlert(
          context, "Error", MdiIcons.close, 'Something went wrong', Colors.red);
    }
  }

  AlertMessage alert = AlertMessage();
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
    getTimeSheetData();
    super.initState();
  }

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
      body: flag == 1
          ? Column(
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
                              String monthChoosenIndexToString =
                                  '${monthString.indexOf(monthChoosen) + 1}';

                              getShortedTimeSheetData(
                                  monthChoosenIndexToString, yearChoosen);
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
                                onPressed: getTimeSheetData,
                                child: Text('Reset')))),
                    SizedBox(
                      width: 20.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 200.0,
                ),
                Center(child: Text('No Data Found')),
              ],
            )
          : ModalProgressHUD(
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
                                  String monthChoosenIndexToString =
                                      '${monthString.indexOf(monthChoosen) + 1}';
                                  getShortedTimeSheetData(
                                      monthChoosenIndexToString, yearChoosen);
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
                                    onPressed: getTimeSheetData,
                                    child: Text('Reset')))),
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
                      rows: userEntryRecord
                          .map(
                            (user) => DataRow(
                              cells: [
                                DataCell(
                                  Center(child: Text(user.userName)),
                                ),
                                DataCell(Center(child: Text(user.enterTime))),
                                DataCell(Center(child: Text(user.exitTime))),
                                DataCell(Center(
                                    child: Text(
                                  user.totalHour,
                                ))),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
