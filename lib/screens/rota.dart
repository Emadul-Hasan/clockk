import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'notification.dart';

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
        // print(data);
        var value = data['data'];
        // print(value);
        for (var item in value) {
          var date = item['date'].split('-');
          var sTime = item['start_time'].split(':');
          var eTime = item['end_time'].split(':');

          setState(() {
            DateTime taskDateTimeStart = DateTime(
              int.parse(date[0]),
              int.parse(date[1]),
              int.parse(date[2]),
              int.parse(sTime[0]),
              int.parse(sTime[1]),
              int.parse(sTime[2]),
            );
            DateTime taskDateTimeEnd = DateTime(
              int.parse(date[0]),
              int.parse(date[1]),
              int.parse(date[2]),
              int.parse(eTime[0]),
              int.parse(eTime[1]),
              int.parse(eTime[2]),
            );
            meetings.add(Appointment(
              startTime: taskDateTimeStart,
              endTime: taskDateTimeEnd,
              subject: '$taskDateTimeStart to $taskDateTimeEnd',
              color: color[index],
            ));
            if (index == 3) {
              index = 0;
            } else {
              index++;
            }
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

  int index = 0;
  List<Color> color = [
    Colors.green,
    Colors.blue,
    Colors.deepPurple,
    Colors.orange
  ];
  List<Appointment> meetings = [];

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
      appBar: CustomAppBar(Text("Rota"),(){
        Navigator.pushNamed(context, Notifications.id);
      }),
      body: SfCalendar(
        view: CalendarView.week,
        firstDayOfWeek: 6,
        dataSource: MeetingDataSource(meetings),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
