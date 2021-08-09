import 'dart:async';
import 'dart:convert';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/models/AlertModel.dart';
import 'package:clockk/models/connectivityCheck.dart';
import 'package:clockk/models/stuffInMyTaskTiles.dart';
import 'package:clockk/models/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'notification.dart';

class MyCheckList extends StatefulWidget {
  static const id = "MyCheckList";
  @override
  _MyCheckListState createState() => _MyCheckListState();
}

class _MyCheckListState extends State<MyCheckList> {
  List<MyTile> listOfTiles = <MyTile>[];

  Future<void> getTaskData() async {
    listOfTiles.clear();
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/my_check_list";
    var url = Uri.parse(webUrl);
    print(webUrl);

    try {
      http.Response response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      });

      if (response.statusCode == 200) {
        try {
          var data = jsonDecode(response.body);
          print(data);
          var allTask = data['data']['checklist'];

          if (allTask != []) {
            for (var item in allTask) {
              print(item);
              List<MyTile> subtasks = [];
              if (item['task'] != []) {
                for (var items in item['task']) {
                  print(item['title']);
                  subtasks.add(new MyTile(
                      items['name'].toString(), false, items['id'].toString()));
                  print(items);
                }
              }
              setState(() {
                if (subtasks != []) {
                  listOfTiles.add(
                    new MyTile(item['title'].toString(), false,
                        item['id'].toString(), subtasks),
                  );
                } else if (subtasks != [] || allTask != []) {
                  listOfTiles.add(
                    new MyTile(
                        item['title'].toString() == ''
                            ? "Untitled Task"
                            : item['title'].toString(),
                        false,
                        item['id'].toString() == ''
                            ? '--'
                            : item['id'].toString(),
                        subtasks),
                  );
                }
              });
            }
          }
          setState(() {
            listOfTiles
                .sort((a, b) => a.children.length.compareTo(b.children.length));
          });
        } catch (e) {
          print(e);
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  AlertMessage alert = AlertMessage();
  // Connectivity check elements

  CheckConnectivity _connectivityCheck = CheckConnectivity();

  void checkConnection() async {
    String resultString = await _connectivityCheck.checkingConnection();
    if (resultString != null) {
      alert.messageAlert(context, "Error", MdiIcons.close,
          'Please turn on connectivity to use this app', Colors.red);
    }
  }

  // Connectivity check

  bool spinner = true;

  @override
  void initState() {
    checkConnection();
    getTaskData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (listOfTiles.isNotEmpty) {
        listOfTiles
            .sort((a, b) => a.children.length.compareTo(b.children.length));
        spinner = false;
      }
    });

    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("My Checklist"), () {
        Navigator.pushNamed(context, Notifications.id);
      }),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: listOfTiles.isEmpty
            ? Center(child: Text('Getting task....'))
            : RefreshIndicator(
                onRefresh: getTaskData,
                child: new ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    var childIndex = -1;
                    if (childIndex < listOfTiles[index].children.length) {
                      childIndex++;
                    } else {
                      childIndex = listOfTiles[index].children.length - 1;
                    }
                    print(listOfTiles[index].children.length);

                    return listOfTiles[index].children.isEmpty
                        ? Card(
                            child: new StuffInMyTaskTiles(
                                listOfTiles[index], listOfTiles[index].isDone),
                          )
                        : new StuffInMyTaskTiles(
                            listOfTiles[index],
                            listOfTiles[index].children[childIndex].isDone,
                          );
                  },
                  itemCount: listOfTiles.length,
                ),
              ),
      ),
    );
  }
}
