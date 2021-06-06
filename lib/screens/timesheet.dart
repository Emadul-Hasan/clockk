import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class TimeSheet extends StatefulWidget {
  static const id = "TimeSheet";
  @override
  _TimeSheetState createState() => _TimeSheetState();
}

class _TimeSheetState extends State<TimeSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Time Sheet")),
      body: Container(
        child: DataTable(
          columns: <DataColumn>[
            DataColumn(label: Text("Date")),
            DataColumn(label: Text("Clock in")),
            DataColumn(label: Text("Clock out")),
            DataColumn(label: Text("Active hour")),
          ],
          rows: UserEntryRecord.map(
            (User) => DataRow(
              cells: [
                DataCell(Text(User.UserName)),
                DataCell(Text(User.EnterTime)),
                DataCell(Text(User.ExitTime)),
                DataCell(Text(User.TotalHour)),
              ],
            ),
          ).toList(),
        ),
      ),
    );
  }
}

class UserEntryModel {
  final String UserName;
  final String EnterTime;
  final String ExitTime;
  final String TotalHour;
  UserEntryModel(this.UserName, this.EnterTime, this.ExitTime, this.TotalHour);
}

List<UserEntryModel> UserEntryRecord = [
  UserEntryModel("4", "10.00AM", "5.00PM", "7"),
  UserEntryModel("5", "10.00AM", "5.00PM", "7"),
  UserEntryModel("6", "10.00AM", "5.00PM", "7"),
  UserEntryModel("7", "11.00AM", "5.00PM", "6"),
];
