import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  static const id = "DashBoard";
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool myChecklistCompleted = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Dashboard")),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Icon(
                    myChecklistCompleted == true
                        ? Icons.radio_button_unchecked
                        : Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Text(
                      "My Check List to be completed",
                      style: TextStyle(fontSize: 17.0),
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      "0",
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Icon(
                    myChecklistCompleted == true
                        ? Icons.radio_button_unchecked
                        : Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Text(
                      "Team Check List to be completed",
                      style: TextStyle(fontSize: 17.0),
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      "0",
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Icon(
                    myChecklistCompleted == false
                        ? Icons.radio_button_unchecked
                        : Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Text(
                      "Task completed today",
                      style: TextStyle(fontSize: 17.0),
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      "0",
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Icon(
                    myChecklistCompleted == true
                        ? Icons.radio_button_unchecked
                        : Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Text(
                      "Total Hours Worked so far",
                      style: TextStyle(fontSize: 17.0),
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      "0",
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
