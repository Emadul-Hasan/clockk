import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/models/taskmodel.dart';
import 'package:flutter/material.dart';

class TeamCheckList extends StatefulWidget {
  static const id = "TeamCheckList";
  @override
  _TeamCheckListState createState() => _TeamCheckListState();
}

class _TeamCheckListState extends State<TeamCheckList> {
  @override
  Widget build(BuildContext context) {
    // listOfTiles
    //     .add(MyTile("Task Name", <MyTile>[MyTile("Sub 1"), MyTile("Sub2")]));
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Team Check List")),
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
  new MyTile('Team Task1', false, <MyTile>[
    new MyTile("Team Sub task1", false),
    new MyTile("Team Sub task2", false),
    new MyTile("Team Sub task3", false),
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
