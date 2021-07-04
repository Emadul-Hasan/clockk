import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TimeSheet extends StatefulWidget {
  static const id = "TimeSheet";
  @override
  _TimeSheetState createState() => _TimeSheetState();
}

class _TimeSheetState extends State<TimeSheet> {
  Future<void> getTimeSheetData() async {
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/timesheet";
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
        var value = data['data'];
        print(value);
        for (var item in value) {
          print(item);
          setState(() {
            UserEntryRecord.add(UserEntryModel(
                item['date'].toString() == "null"
                    ? '--'
                    : item['date'].toString(),
                item['in_time'].toString() == "null"
                    ? '--'
                    : item['in_time'].toString(),
                item['out_time'].toString() == "null"
                    ? '--'
                    : item['out_time'].toString(),
                item['total_hour'].toString() == "null"
                    ? '--'
                    : item['total_hour'].toString()));
            showSpinner = false;
          });
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  List<UserEntryModel> UserEntryRecord = [];

  @override
  void initState() {
    getTimeSheetData();
    super.initState();
  }

  bool showSpinner = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Time Sheet")),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Container(
            child: DataTable(
              columnSpacing: 20.0,
              horizontalMargin: 20.0,
              columns: <DataColumn>[
                DataColumn(label: Text("Date")),
                DataColumn(label: Text("Clock in")),
                DataColumn(label: Text("Clock Out")),
                DataColumn(label: Text("Total Hour")),
              ],
              rows: UserEntryRecord.map(
                (User) => DataRow(
                  cells: [
                    DataCell(
                      Center(child: Text(User.UserName)),
                    ),
                    DataCell(Center(child: Text(User.EnterTime))),
                    DataCell(Center(child: Text(User.ExitTime))),
                    DataCell(Center(
                        child: Text(
                      User.TotalHour,
                    ))),
                  ],
                ),
              ).toList(),
            ),
          ),
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
