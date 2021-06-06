import 'package:flutter/material.dart';

class MyTile {
  String title;
  List<MyTile> children;
  bool isDone;

  MyTile(this.title, this.isDone, [this.children = const <MyTile>[]]);
  void toggleDone() {
    isDone = !isDone;
  }
}

// class Task {
//   final String name;
//   bool isDone;
//
//   Task({@required this.name, @required this.isDone});
//   void toggleDone() {
//     isDone = !isDone;
//   }
// }
