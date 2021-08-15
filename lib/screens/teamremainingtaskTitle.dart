import 'dart:async';
import 'dart:convert';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/models/AlertModel.dart';
import 'package:clockk/models/connectivityCheck.dart';
import 'package:clockk/models/taskmodel.dart';
import 'package:clockk/screens/teamsubtask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'notification.dart';

class TeamRemainingTaskTitle extends StatefulWidget {
  static const id = "TeamCheckListTitle";

  @override
  _TeamRemainingTaskTitleState createState() => _TeamRemainingTaskTitleState();
}

class _TeamRemainingTaskTitleState extends State<TeamRemainingTaskTitle> {
  List<MyTask> listOfTask = [];
  AlertMessage alert = AlertMessage();
  bool showSpinner = true;
  int flag = 1;
  Future<void> getTaskData() async {
    listOfTask.clear();
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/getTeamChecklist";
    var url = Uri.parse(webUrl);
    try {
      http.Response response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      });

      if (response.statusCode == 200) {
        setState(() {
          showSpinner = false;

          var data = jsonDecode(response.body);
          var value = data['data']['checklist'];
          if (value?.isEmpty ?? true) {
            flag = 1;
            setState(() {
              showSpinner = false;
            });
          } else {
            flag = 0;
          }
          for (var item in value) {
            listOfTask.add(new MyTask(
                item['title'].toString(),
                item['id'].toString(),
                item['end_date'].toString(),
                item['total'].toString()));
          }
        });
      } else {
        alert.messageAlert(context, "Error", MdiIcons.close,
            'Something went wrong', Colors.red);
      }
    } catch (e) {
      alert.messageAlert(
          context, "Error", MdiIcons.close, 'Something went wrong', Colors.red);
    }
  }

  CheckConnectivity _connectivityCheck = CheckConnectivity();

  void checkConnection() async {
    String resultString = await _connectivityCheck.checkingConnection();
    if (resultString != null) {
      alert.messageAlert(context, "Error", MdiIcons.close,
          'Please turn on connectivity to use this app', Colors.red);
    }
  }

  @override
  void initState() {
    checkConnection();
    getTaskData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Team Check List"), () {
        Navigator.pushReplacementNamed(context, Notifications.id);
      }),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: flag == 1
            ? Center(
                child: Text("You have no task to see"),
              )
            : RefreshIndicator(
                onRefresh: getTaskData,
                child: new ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            left: 4.0, right: 4.0, top: 10.0, bottom: 10.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context, TeamRemainingSubTask.id,
                                arguments: listOfTask[index].id);
                          },
                          minLeadingWidth: 2.0,
                          horizontalTitleGap: 5.0,
                          title: Text(
                            listOfTask[index].title,
                            style: TextStyle(fontSize: 14.0),
                          ),
                          subtitle: Text(
                            'Due Date: ${listOfTask[index].time}\t Task Count:${listOfTask[index].totalCount}',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, TeamRemainingSubTask.id,
                                  arguments: listOfTask[index].id);
                            },
                            icon: Icon(MdiIcons.arrowRight),
                          ),
                        ),
                      )),
                    );
                  },
                  itemCount: listOfTask.length,
                ),
              ),
      ),
    );
  }
}
