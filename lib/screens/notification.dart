import 'dart:convert';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/models/AlertModel.dart';
import 'package:clockk/models/connectivityCheck.dart';
import 'package:clockk/models/notificationModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Notifications extends StatefulWidget {
  static const id = "Notifications";
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Future<void> getNotificationData() async {
    notifications.clear();
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/notification";
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
            notifications.add(new NotificationModel(
                title: item['title'].toString(), id: item['id'].toString()));
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

  String removeId = '0';
  Future<void> removeNotificationData(String api) async {
    notifications.clear();
    setState(() {
      showSpinner = true;
    });
    var token = await FlutterSession().get('token');
    String webUrl = api;
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
            notifications.add(new NotificationModel(
                title: item['title'].toString(), id: item['id'].toString()));
          }
          alert.messageAlert(
              context, 'Status', MdiIcons.check, data['message'], Colors.green);
        });
      } else {
        alert.messageAlert(
            context, 'Status', MdiIcons.close, 'Failed', Colors.red);
      }
    } catch (e) {
      alert.messageAlert(
          context, "Error", MdiIcons.close, 'Something went wrong', Colors.red);
    }
  }

  AlertMessage alert = AlertMessage();
  bool showSpinner = true;
  int flag = 0;

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
    getNotificationData();
    super.initState();
  }

  List<NotificationModel> notifications = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 8.0, right: 8.0),
        child: ElevatedButton(
          child: Text('clear all'),
          onPressed: () {
            setState(() {
              removeNotificationData(
                  'https://clockk.in/api/notification_delete_all');
            });
          },
        ),
      ),
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Notifications"), () {
        Navigator.pushReplacementNamed(context, Notifications.id);
      }),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: flag == 1
            ? Center(
                child: Text("You have no notification to see"),
              )
            : RefreshIndicator(
                onRefresh: getNotificationData,
                child: new ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            left: 4.0, right: 4.0, top: 10.0, bottom: 10.0),
                        child: ListTile(
                          minLeadingWidth: 2.0,
                          horizontalTitleGap: 5.0,
                          leading: Icon(
                            MdiIcons.alarm,
                            color: Colors.orange,
                            size: 25.0,
                          ),
                          title: Text(
                            notifications[index].title,
                            style: TextStyle(fontSize: 14.0),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  removeNotificationData(
                                      'https://clockk.in/api/notification_delete/${notifications[index].id}');
                                });
                              },
                              icon: Icon(MdiIcons.close)),
                        ),
                      )),
                    );
                  },
                  itemCount: notifications.length,
                ),
              ),
      ),
    );
  }
}
