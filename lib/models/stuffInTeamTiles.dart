import 'dart:convert';

import 'package:clockk/models/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'AlertModel.dart';

class StuffInTeamTiles extends StatefulWidget {
  final MyTile myTile;

  bool currentState;
  StuffInTeamTiles(this.myTile, this.currentState);

  @override
  _StuffInTeamTilesState createState() => _StuffInTeamTilesState();
}

class _StuffInTeamTilesState extends State<StuffInTeamTiles> {
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
              print(token);

              String webUrl =
                  "https://clockk.in/api/team_check_list_complete?task_id=$subtaskID&comment=${comment == '' ? ' ' : comment}";
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
                  alert.messageAlert(
                      context, 'Status', MdiIcons.check, message, Colors.green);
                } else {
                  alert.messageAlert(context, 'Status', MdiIcons.close,
                      'Sending failed try again', Colors.red);
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

  AlertMessage alert = AlertMessage();

  Widget _buildTiles(MyTile t) {
    if (t.children.isEmpty)
      return Visibility(
        visible: t.isDone ? false : true,
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
              // activeColor: Colors.white,
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
                decoration: t.isDone ? TextDecoration.lineThrough : null,
              ),
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
