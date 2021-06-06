// /// ListTile
//
// import 'package:flutter/material.dart';
//
// import 'package:clockk/custom_component/ToDoListView.dart';
// import 'package:clockk/custom_component/TodoListTile.dart';
// import 'package:clockk/custom_component/customappbar.dart';
// import 'package:clockk/custom_component/drawerCustomList.dart';
// import 'package:clockk/models/taskmodel.dart';
// import 'package:flutter/material.dart';
//
// class TaskNSubTask extends StatefulWidget {
//   static const id = "TaskNSubTask";
//   @override
//   _TaskNSubTaskState createState() => _TaskNSubTaskState();
// }
//
// class _TaskNSubTaskState extends State<TaskNSubTask> {
//   @override
//   Widget build(BuildContext context) {
//     listOfTiles
//         .add(MyTile("Task Name", <MyTile>[MyTile("Sub 1"), MyTile("Sub2")]));
//     return Scaffold(
//       drawer: DrawerCustomList(),
//       appBar: CustomAppBar(Text("Test")),
//       body: new ListView.builder(
//         itemBuilder: (BuildContext context, int index) {
//           return new StuffInTiles(listOfTiles[index]);
//         },
//         itemCount: listOfTiles.length,
//       ),
//     );
//   }
// }
//
// class StuffInTiles extends StatelessWidget {
//   final MyTile myTile;
//   StuffInTiles(this.myTile);
//
//   @override
//   Widget build(BuildContext context) {
//     return _buildTiles(myTile);
//   }
//
//   Widget _buildTiles(MyTile t) {
//     if (t.children.isEmpty)
//       return new ListTile(
//           dense: true,
//           enabled: true,
//           isThreeLine: false,
//           onLongPress: () => print("long press"),
//           onTap: () => print("tap"),
//           leading: Checkbox(
//             value: false,
//             onChanged: (value) {
//               print(value);
//             },
//           ),
//           selected: true,
//           title: new Text(t.title));
//
//     return new ExpansionTile(
//       key: new PageStorageKey<int>(3),
//       title: new Text(t.title),
//       children: t.children.map(_buildTiles).toList(),
//     );
//   }
// }
//
// class MyTile {
//   String title;
//   List<MyTile> children;
//   MyTile(this.title, [this.children = const <MyTile>[]]);
// }
//
// List<MyTile> listOfTiles = <MyTile>[
//   new MyTile(
//     'Task1',
//     <MyTile>[
//       new MyTile('Sub Task1'),
//       new MyTile('Sub T2'),
//       new MyTile('Sub T3'),
//     ],
//   ),
//   new MyTile(
//     'Task 2',
//     <MyTile>[
//       new MyTile('Sub 1'),
//       new MyTile('Sub 2'),
//     ],
//   ),
//   new MyTile(
//     'Task 3',
//     <MyTile>[
//       new MyTile('Sub 1'),
//       new MyTile('Sub 2'),
//       new MyTile('Sub 3'),
//     ],
//   ),
// ];
