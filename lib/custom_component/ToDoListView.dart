// import 'package:clockk/models/taskmodel.dart';
// import 'package:flutter/material.dart';
// import 'TodoListTile.dart';
//
// class TodoListView extends StatefulWidget {
//   @override
//   _TodoListViewState createState() => _TodoListViewState();
// }
//
// class _TodoListViewState extends State<TodoListView> {
//   List<Task> TaskList = [
//     Task(name: "Task 1", isDone: false),
//     Task(name: "Task 2", isDone: false),
//     Task(name: "Task 3", isDone: false),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemBuilder: (context, index) {
//         return TodoListTile(
//           taskTitle: TaskList[index].name,
//           onchangeSate: TaskList[index].isDone,
//           onChangeValue: (checkboxState) {
//             setState(() {
//               TaskList[index].toggleDone();
//             });
//           },
//         );
//       },
//       itemCount: TaskList.length,
//     );
//   }
// }
