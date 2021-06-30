import 'dart:convert';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/custom_component/inputfield.dart';
import 'package:clockk/models/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

class MyCheckList extends StatefulWidget {
  static const id = "MyCheckList";
  @override
  _MyCheckListState createState() => _MyCheckListState();
}

class _MyCheckListState extends State<MyCheckList> {
  Future<void> getTaskData() async {
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/team_check_list";
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

  @override
  Widget build(BuildContext context) {
    // listOfTiles
    //     .add(MyTile("Task Name", <MyTile>[MyTile("Sub 1"), MyTile("Sub2")]));
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("My Check List")),
      body: new ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return new StuffInTiles(
            listOfTiles[index],
            listOfTiles[index].children[index].isDone,
          );
        },
        itemCount: listOfTiles.length,
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

  _onAlertWithCustomContentPressed(context, String subtask) {
    Alert(
        context: context,
        title: "Post Comment",
        content: Column(
          children: <Widget>[
            TextField(
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
            onPressed: () {
              print(subtask);
              Navigator.pop(context);
            },
            child: Text(
              "Send",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]).show();
  }

  Widget _buildTiles(MyTile t) {
    if (t.children.isEmpty)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () => print("long press"),
          onTap: () => print(t.title),
          leading: Checkbox(
            value: t.isDone,
            onChanged: (value) {
              setState(() {
                t.isDone = !t.isDone;
                _onAlertWithCustomContentPressed(context, t.title);
              });
            },
          ),
          selected: true,
          title: new Text(
            t.title,
            style: TextStyle(
                decoration: t.isDone ? TextDecoration.lineThrough : null),
          ));

    return Card(
      child: new ExpansionTile(
        key: new PageStorageKey<int>(3),
        title: new Text(t.title),
        children: t.children.map(_buildTiles).toList(),
      ),
    );
  }
}

List<MyTile> listOfTiles = <MyTile>[
  new MyTile('Task1', false, <MyTile>[
    new MyTile("Sub task1", false),
    new MyTile("Sub task2", false),
    new MyTile("Sub task3", false),
  ]),
  new MyTile('Task1', false, <MyTile>[
    new MyTile("Sub task1", false),
    new MyTile("Sub task2", false),
    new MyTile("Sub task3", false),
  ]),
  // new MyTile(
  //   'Task 2',
  //   <MyTile>[
  //     new MyTile('Sub 1'),
  //     new MyTile('Sub 2'),
  //   ],
  // ),
  // new MyTile(
  //   'Task 3',
  //   <MyTile>[
  //     new MyTile('Sub 1'),
  //     new MyTile('Sub 2'),
  //     new MyTile('Sub 3'),
  //   ],
  // ),
];

// class MyCheckList extends StatefulWidget {
//   static const id = "MyCheckList";
//   @override
//   _MyCheckListState createState() => _MyCheckListState();
// }
//
// class _MyCheckListState extends State<MyCheckList> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: DrawerCustomList(),
//       appBar: CustomAppBar(Text("My Task List")),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//               child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20.0),
//                 topRight: Radius.circular(20.0),
//               ),
//             ),
//             child: TodoListView(),
//           )),
//         ],
//       ),
//     );
//   }
// }
