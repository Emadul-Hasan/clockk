import 'package:flutter/material.dart';

class MyTile {
  String title;
  String id;
  List<MyTile> children;
  bool isDone;

  MyTile(this.title, this.isDone,this.id, [this.children = const <MyTile>[]]);
  void toggleDone() {
    isDone = !isDone;
  }
}


