import 'dart:convert';
import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/models/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

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
        try{
          var data = jsonDecode(response.body);
          print(data);
          var allTask = data['data']['checklist'];

          if(allTask != []){
          for(var item in allTask){
            print(item);
            List<MyTile> subtasks= [];
            if(item['task'] != []){
            for(var items in item['task'] ){

              print(item['title']);
              subtasks.add(new MyTile(items['name'].toString(), false,items['id'].toString()));
              print(items);
             }}
            setState(() {
              if(subtasks != []){
              listOfTiles.add(new MyTile(item['title'].toString(), false,item['id'].toString(), subtasks),
              );
                }else if (subtasks != [] || allTask != []){
                listOfTiles.add(new MyTile(item['title'].toString()==''?"Untitled Task": item['title'].toString(), false,item['id'].toString()==''?'--':item['id'].toString(), subtasks),
                );
              }
            });
        }
          }
          setState(() {
            listOfTiles.sort((a,b)=> a.children.length.compareTo(b.children.length));
          });



        }catch(e){
          print(e);
        }

      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getTaskData();
    super.initState();
  }
bool spinner = true;
  @override
  Widget build(BuildContext context) {

    setState(() {
      if (listOfTiles.isNotEmpty){
        listOfTiles.sort((a,b)=> a.children.length.compareTo(b.children.length));
        spinner = false;
      }
    });


    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("My Checklist"),(){
        Navigator.pushNamed(context, Notifications.id);
      }),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: listOfTiles.isEmpty?Center(child: Text('Getting task....')): RefreshIndicator(
          onRefresh:getTaskData,
          child: new ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              var childIndex = -1;
              if (childIndex < listOfTiles[index].children.length){
                childIndex++;
              }
              else{
                childIndex = listOfTiles[index].children.length -1;
              }
              print(listOfTiles[index].children.length);

              return listOfTiles[index].children.isEmpty? Card(
                child: new StuffInTiles(
                  listOfTiles[index],
                  listOfTiles[index].isDone
                ),
              ): new StuffInTiles(
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

class StuffInTiles extends StatefulWidget {
  final MyTile myTile;

  bool currentState;
  StuffInTiles(this.myTile, this.currentState);

  @override
  _StuffInTilesState createState() => _StuffInTilesState();
}

class _StuffInTilesState extends State<StuffInTiles> {
  @override
  Widget build(BuildContext context) {
    return _buildTiles(widget.myTile);
  }

  _onAlertWithCustomContentPressed(context, String subtaskID) {
    String comment = '';
    Alert(
        context: context,
        title: "Post Comment",
        content: Column(
          children: <Widget>[
            TextField(
              onChanged: (value){
                comment = value;
              },
              obscureText: true,
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
            onPressed: () async{
              Navigator.pop(context);
              var token = await FlutterSession().get('token');
              print(token);

              print(subtaskID);

              String webUrl =
                  "https://clockk.in/api/my_check_list_complete?task_id=$subtaskID&comment=${comment==''?' ': comment}";
              var url = Uri.parse(webUrl);
              print(webUrl);

              try {
                http.Response response = await http.post(url, headers: {
                  'Content-type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': token
                });

                if (response.statusCode == 200) {
                  print(response.body);
                  var body = jsonDecode(response.body);
                  String message = body['message'];
                  _onAlertMessage(context, message);

                } else {
                  _onAlertMessage(context, 'Sending Failed');
                }
              } catch (e) {
                print(e);
              }

            },
            child: Text(
              "Send",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]).show();
  }

  _onAlertMessage(context, String message) {

    Alert(
        context: context,
        title: "Status",
        content: Column(
          children: <Widget>[
            Text(message)
          ],
        ),
        buttons: [
          DialogButton(
            width: 60.0,
            color: Colors.lightBlueAccent,
            onPressed: () async{
              Navigator.pop(context);
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]).show();
  }



  Widget _buildTiles(MyTile t) {
    if (t.children.isEmpty)
      return Visibility(
        visible: t.isDone? false: true,
        child: new ListTile(
            dense: true,
            enabled: true,
            isThreeLine: false,
            // onLongPress: () =>  _onAlertWithCustomContentPressed(context, t.id),
            onTap: () {
              setState(() {
              t.isDone = !t.isDone;

              _onAlertWithCustomContentPressed(context, t.id);
            });
            },
            leading: Checkbox(
              value: t.isDone,
              onChanged: (value) {
                setState(() {
                  t.isDone = !t.isDone;

                  _onAlertWithCustomContentPressed(context, t.id);

                });
              },
            ),
            selected: true,
            title: new Text(
              t.title,
              style: TextStyle(
                  decoration: t.isDone ? TextDecoration.lineThrough : null),
            )),
      );

    return Card(
      child: new ExpansionTile(
        key: new PageStorageKey<int>(3),
        title: new Text(t.title),
        children: t.children.map(_buildTiles).toList(),
      ),
    );
  }
}



