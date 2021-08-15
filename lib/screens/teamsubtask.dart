import 'dart:async';
import 'dart:convert';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/models/AlertModel.dart';
import 'package:clockk/models/connectivityCheck.dart';
import 'package:clockk/models/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'notification.dart';

class TeamRemainingSubTask extends StatelessWidget {
  const TeamRemainingSubTask({Key key}) : super(key: key);
  static const id = "TeamSubtask";
  @override
  Widget build(BuildContext context) {
    final String args = ModalRoute.of(context).settings.arguments;
    return RemainingSubTaskToCompleteTeam(getID: args);
  }
}

class RemainingSubTaskToCompleteTeam extends StatefulWidget {
  RemainingSubTaskToCompleteTeam({this.getID});
  final String getID;
  @override
  _RemainingSubTaskToCompleteTeamState createState() =>
      _RemainingSubTaskToCompleteTeamState(taskId: getID);
}

class _RemainingSubTaskToCompleteTeamState
    extends State<RemainingSubTaskToCompleteTeam> {
  _RemainingSubTaskToCompleteTeamState({this.taskId});

  String formattedDateTime;
  DateTime timeNow;
  String taskId;
  String barTitle;
  List<MySubTask> listOfTask = [];
  AlertMessage alert = AlertMessage();
  bool showSpinner = true;
  int flag = 1;
  List<String> listOfCompleteId = [];

  Future<void> getTaskData() async {
    listOfTask.clear();
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/team_check_list/$taskId";
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
          barTitle = value[0]["title"];

          if (value?.isEmpty ?? true) {
            flag = 1;
            setState(() {
              showSpinner = false;
            });
          } else {
            flag = 0;
          }
          for (var item in value) {
            for (var items in item['task']) {
              listOfTask.add(new MySubTask(
                  title: items['name'].toString(),
                  id: items['id'].toString(),
                  isDone: false,
                  time: items['end_date'].toString()));
            }
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

  _onAlertWithCustomContentPressed(context) {
    setState(() {
      showSpinner = true;
    });
    String comment = '';
    Alert(
        closeFunction: () {
          setState(() {
            Navigator.pop(context);
            showSpinner = false;
          });
        },
        closeIcon: Icon(MdiIcons.close),
        context: context,
        title: "Comment",
        content: Column(
          children: <Widget>[
            TextField(
              onChanged: (value) {
                comment = value;
              },
              obscureText: false,
              decoration: InputDecoration(
                icon: Icon(MdiIcons.message),
                labelText: 'Comment',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            width: 60.0,
            color: Colors.lightBlueAccent,
            onPressed: () async {
              Navigator.pop(context);
              var token = await FlutterSession().get('token');

              String completedIds;
              for (var items in listOfCompleteId) {
                if (completedIds == null) {
                  completedIds = items;
                } else {
                  completedIds = completedIds + ',' + items.toString();
                }
              }

              String webUrl =
                  "https://clockk.in/api/team_check_list_complete?task_id=$completedIds&comment=${comment == '' ? 'No Comment' : comment}&title_id=$taskId";
              var url = Uri.parse(webUrl);
              try {
                http.Response response = await http.post(url, headers: {
                  'Content-type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': token
                });

                if (response.statusCode == 200) {
                  var body = jsonDecode(response.body);
                  String message = body['message'];
                  alert.messageAlert(
                      context, 'Status', MdiIcons.check, message, Colors.green);

                  List<int> indexToHide = [];
                  for (var item in listOfCompleteId) {
                    final indexNum =
                        listOfTask.indexWhere((element) => element.id == item);
                    indexToHide.add(indexNum);
                  }
                  indexToHide = indexToHide.toSet().toList();

                  for (var index in indexToHide) {
                    setState(() {
                      listOfTask[index].visible = false;
                      showSpinner = false;
                    });
                  }

                  // getTaskData();
                  listOfCompleteId.clear();
                } else {
                  alert.messageAlert(context, 'Status', MdiIcons.close,
                      'Sending failed try again', Colors.red);
                  // getTaskData();
                }
              } catch (e) {
                alert.messageAlert(context, "Error", MdiIcons.close,
                    'Something went wrong', Colors.red);
              }
              setState(() {
                listOfCompleteId.clear();
                completedIds = null;
              });
            },
            child: Text(
              "Send",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]).show();
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
    setState(() {
      timeNow = DateTime.now();
      formattedDateTime =
          "${timeNow.day}/${timeNow.month}/${timeNow.year} ${timeNow.hour.toString().padLeft(2, '0')}:${timeNow.minute.toString().padLeft(2, '0')}:${timeNow.second.toString().padLeft(2, '0')}";
    });
    return Scaffold(
      floatingActionButton: Visibility(
        visible: listOfCompleteId.isEmpty ? false : true,
        child: Container(
          margin: EdgeInsets.all(25.0),
          child: IconButton(
              onPressed: () {
                setState(() {
                  _onAlertWithCustomContentPressed(context);
                });
              },
              icon: Icon(MdiIcons.sendCircle, color: Colors.blue, size: 70.0)),
        ),
      ),
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text(barTitle != null ? barTitle : "Sub Task"), () {
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
                    return Visibility(
                      visible:
                          listOfTask[index].visible == false ? false : true,
                      child: Container(
                        margin: EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.only(
                              left: 4.0, right: 4.0, top: 10.0, bottom: 10.0),
                          child: ListTile(
                            minLeadingWidth: 2.0,
                            horizontalTitleGap: 5.0,
                            subtitle: Text(listOfTask[index].isDone
                                ? 'Completed on: $formattedDateTime'
                                : 'Due Date: ${listOfTask[index].time}'),
                            leading: Checkbox(
                              value: listOfTask[index].isDone,
                              onChanged: (value) {
                                setState(() {
                                  listOfTask[index].isDone =
                                      !listOfTask[index].isDone;
                                  if (listOfTask[index].isDone == true) {
                                    listOfCompleteId.add(listOfTask[index].id);
                                  } else {
                                    listOfCompleteId
                                        .remove(listOfTask[index].id);
                                  }
                                });
                              },
                            ),
                            title: Text(
                              listOfTask[index].title,
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        )),
                      ),
                    );
                  },
                  itemCount: listOfTask.length,
                ),
              ),
      ),
    );
  }
}
