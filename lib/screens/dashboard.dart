import 'dart:async';
import 'dart:convert';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/models/AlertModel.dart';
import 'package:clockk/models/connectivityCheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'notification.dart';

class DashBoard extends StatefulWidget {
  static const id = "DashBoard";
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  var getData;
  bool showSpinner = true;
  bool myChecklistCompleted = true;
  String myCheckListNumber = '-';
  String teamCheckListNumber = '-';
  String taskCompleteNumber = '0';
  String workedHour = '__:__:__';
  String weeklyWorkedHour = '__:__:__';

  AlertMessage alert = AlertMessage();

  // Connectivity check elements

  CheckConnectivity _connectivityCheck = CheckConnectivity();

  void checkConnection() async {
    String resultString = await _connectivityCheck.checkingConnection();
    if (resultString != null) {
      alert.messageAlert(
          context, "Error", MdiIcons.close, resultString, Colors.red);
    }
  }

  // Connectivity check

  Future<void> getDashBoardData() async {
    setState(() {
      showSpinner = true;
    });
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/dashboard";
    var url = Uri.parse(webUrl);
    try {
      http.Response response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        getData = data['data'];

        setState(() {
          myCheckListNumber = getData[0]['my_checklist'].toString();
          teamCheckListNumber = getData[0]['team_checklist'].toString();
          if (getData[0]['total_worked_today'] != 0) {
            workedHour = getData[0]['total_worked_today'].toString();
          }
          if (getData[0]['total_worked_weekly'] != 0) {
            weeklyWorkedHour = getData[0]['total_worked_weekly'].toString();
          }

          taskCompleteNumber = getData[0]['task_done'].toString();
        });

        setState(() {
          showSpinner = false;
        });
      } else {
        setState(() {
          showSpinner = false;
        });
      }
    } catch (e) {
      alert.messageAlert(
          context, "Error", MdiIcons.close, 'Something went wrong', Colors.red);
    }
  }

  @override
  void initState() {
    checkConnection();
    getDashBoardData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: getDashBoardData,
        child: Icon(MdiIcons.refresh),
      ),
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Dashboard"), () {
        Navigator.pushNamed(context, Notifications.id);
      }),
      body: getData == null
          ? ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Center(
                child: Text('Getting updated data...'),
              ))
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Icon(
                          myCheckListNumber != '0'
                              ? Icons.radio_button_unchecked
                              : Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                          flex: 5,
                          child: Text(
                            "My Remaining Tasks",
                            style: TextStyle(fontSize: 17.0),
                          )),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            myCheckListNumber,
                            style: TextStyle(fontSize: 17.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Icon(
                          teamCheckListNumber != '0'
                              ? Icons.radio_button_unchecked
                              : Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                          flex: 5,
                          child: Text(
                            "Team Remaining Tasks",
                            style: TextStyle(fontSize: 17.0),
                          )),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            teamCheckListNumber,
                            style: TextStyle(fontSize: 17.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Icon(
                          taskCompleteNumber == '0'
                              ? Icons.radio_button_unchecked
                              : Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                          flex: 5,
                          child: Text(
                            "Tasks Completed Today",
                            style: TextStyle(fontSize: 17.0),
                          )),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            taskCompleteNumber,
                            style: TextStyle(fontSize: 17.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Icon(
                          myChecklistCompleted == true
                              ? Icons.radio_button_unchecked
                              : Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                          flex: 5,
                          child: Text(
                            "Total Time In Today",
                            style: TextStyle(fontSize: 17.0),
                          )),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            workedHour,
                            style: TextStyle(fontSize: 17.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Icon(
                          myChecklistCompleted == true
                              ? Icons.radio_button_unchecked
                              : Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                          flex: 5,
                          child: Text(
                            "Total Time In This week",
                            style: TextStyle(fontSize: 17.0),
                          )),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            weeklyWorkedHour,
                            style: TextStyle(fontSize: 17.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
