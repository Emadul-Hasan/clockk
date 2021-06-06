import 'package:flutter/material.dart';

class TodoListTile extends StatelessWidget {
  final String taskTitle;
  final bool onchangeSate;
  final Function onChangeValue;

  TodoListTile(
      {@required this.taskTitle,
      @required this.onchangeSate,
      @required this.onChangeValue});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(taskTitle,
            style: TextStyle(
                fontSize: 18.0,
                decoration: onchangeSate ? TextDecoration.lineThrough : null)),
        leading: Checkbox(
          value: onchangeSate,
          onChanged: onChangeValue,
        ),
        // trailing: Icon(),
      ),
    );
  }
}
