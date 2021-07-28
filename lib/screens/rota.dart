import 'dart:convert';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
  final CalendarController _controller = CalendarController();
  DateTime pickerDefault;
  DateTime startDate;
  DateTime endDate;

  @override
  void initState() {
    getRotaData();
    pickerDefault = DateTime.now();
    super.initState();
  }

  _pickerStartDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: pickerDefault,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (date != null) {
      setState(() {
        startDate = date;
      });
    }
  }

  _pickerEndDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: pickerDefault,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (date != null) {
      setState(() {
        endDate = date;
      });
    }
  }

  _onSuccessToClockin(context, String title, String text) {
    Alert(
        context: context,
        title: title,
        style: AlertStyle(
          titleStyle: TextStyle(
              fontSize: 1.0,
              fontWeight: FontWeight.normal,
              color: Colors.white),
        ),
        closeIcon: Icon(MdiIcons.close),
        content: Center(
          child: Column(
            children: [
              Icon(
                MdiIcons.alert,
                color: Colors.orange,
                size: 50.0,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
              ),
            ],
          ),
        ),
        buttons: []).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Rota"), () {
        Navigator.pushNamed(context, Notifications.id);
      }),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                width: 100.0,
                height: 35.0,
                // color: Colors.grey,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextButton(
                    onPressed: _pickerStartDate,
                    child: Text(startDate == null
                        ? 'Start Date'
                        : '${startDate.day}.${startDate.month}.${startDate.year}')),
              ),
              Text(
                ' - ',
                style: TextStyle(fontSize: 20.0, color: Colors.blue),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                height: 35.0,
                width: 100.0,
                // color: Colors.grey,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextButton(
                    onPressed: _pickerEndDate,
                    child: Text(endDate == null
                        ? 'End Date'
                        : '${endDate.day}.${endDate.month}.${endDate.year}')),
              ),
              SizedBox(
                width: 5.0,
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                height: 35.0,
                width: 100.0,
                // color: Colors.grey,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(
                      color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      if (startDate != null && endDate != null) {
                        String dateFrom =
                            '${startDate.day}.${startDate.month}.${startDate.year}';
                        String dateTo =
                            '${endDate.day}.${endDate.month}.${endDate.year}';
                        print(dateFrom);
                        print(dateTo);
                      } else {
                        _onSuccessToClockin(context, 'Error',
                            'Start date or end date is missing');
                      }
                    });
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SfCalendar(
              controller: _controller,
              allowedViews: [
                CalendarView.month,
                CalendarView.week,
                CalendarView.workWeek,
                CalendarView.timelineDay,
                CalendarView.timelineWeek,
              ],
              view: CalendarView.week,
              firstDayOfWeek: 6,
              dataSource: MeetingDataSource(meetings),
            ),
          ),
        ],
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
