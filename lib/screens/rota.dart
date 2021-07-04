import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Rota extends StatefulWidget {
  static const id = "Rota";
  @override
  _RotaState createState() => _RotaState();
}

class _RotaState extends State<Rota> {
  Future<void> getRotaData() async {
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/rota";
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

  List<Appointment> meetings = [];
  List<Appointment> getAppointments() {
    final DateTime toDay = DateTime.now();
    final DateTime startTime =
        DateTime(toDay.year, toDay.month, toDay.day, 11, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 3));
    meetings.add(Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: "Task 1",
        color: Colors.green,
        recurrenceRule: "FREQ=DAILY;COUNT=5"));

    return meetings;
  }

  bool showSpinner = true;

  @override
  void initState() {
    getRotaData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Rota")),
      body: SfCalendar(
        view: CalendarView.day,
        firstDayOfWeek: 6,
        dataSource: MeetingDataSource(getAppointments()),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
