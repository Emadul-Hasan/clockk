import 'dart:convert';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/models/AlertModel.dart';
import 'package:clockk/models/connectivityCheck.dart';
import 'package:clockk/models/meetingDataSource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'notification.dart';

class Rota extends StatefulWidget {
  static const id = "Rota";
  @override
  _RotaState createState() => _RotaState();
}

class _RotaState extends State<Rota> {
  Future<void> getRotaData() async {
    meetings.clear();
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
          setState(() {
            flag = 0;
          });
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
              subject: '${date[2]}/${date[1]}/${date[0]} ${sTime[0]}:${sTime[1]} to ${date[2]}/${date[1]}/${date[0]} ${sTime[0]}:${sTime[1]}',
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

  AlertMessage alert = AlertMessage();
  int flag = 0;

  Future<void> getShortedRotaData(String fromDate, String toDate) async {
    setState(() {
      showSpinner = true;
    });
    meetings.clear();
    var token = await FlutterSession().get('token');
    String webUrl =
        "https://clockk.in/api/rota?start_date=$fromDate&end_date=$toDate";
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
        if (value?.isEmpty ?? true) {
          flag = 1;
          setState(() {
            showSpinner = false;
          });
        } else {
          flag = 0;
          setState(() {
            _controller.displayDate = startDate;
            _controller.view = CalendarView.month;
          });
        }
        for (var item in value) {
          var date = item['date'].split('-');
          var sTime = item['start_time'].split(':');
          var eTime = item['end_time'].split(':');

          setState(() {
            showSpinner = false;
            DateTime taskDateTimeStart = DateTime(
              int.parse(date[0]),
              int.parse(date[1]),
              int.parse(date[2]),
              int.parse(sTime[0]),
              int.parse(sTime[1]),
            );
            DateTime taskDateTimeEnd = DateTime(
              int.parse(date[0]),
              int.parse(date[1]),
              int.parse(date[2]),
              int.parse(eTime[0]),
              int.parse(eTime[1]),
            );
            meetings.add(Appointment(
              startTime: taskDateTimeStart,
              endTime: taskDateTimeEnd,
              subject: '${date[2]}/${date[1]}/${date[0]} ${sTime[0]}:${sTime[1]} to ${date[2]}/${date[1]}/${date[0]} ${sTime[0]}:${sTime[1]}',
              color: color[index],
            ));
            if (index == 3) {
              index = 0;
            } else {
              index++;
            }
          });
        }
        print(meetings);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  CheckConnectivity _connectivityCheck = CheckConnectivity();
  void checkConnection() async {
    String resultString = await _connectivityCheck.checkingConnection();
    if (resultString != null) {
      alert.messageAlert(
          context, "Error", MdiIcons.close, resultString, Colors.red);
    }
  }

  @override
  void initState() {
    checkConnection();
    getRotaData();
    pickerDefault = DateTime.now();
    super.initState();
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
                            '${startDate.year}-${startDate.month}-${startDate.day}';
                        String dateTo =
                            '${endDate.year}-${endDate.month}-${endDate.day}';
                        print(dateFrom);
                        print(dateTo);
                        getShortedRotaData(dateFrom, dateTo);
                      } else {
                        alert.messageAlert(context, 'Error', MdiIcons.alert,
                            'Start date or end date is missing', Colors.orange);
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
                CalendarView.day,
              ],
              view: CalendarView.month,
              firstDayOfWeek: 6,
              dataSource: MeetingDataSource(meetings),
              monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                  agendaViewHeight: 110,
                  navigationDirection: MonthNavigationDirection.horizontal,
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment),
            ),
          ),
        ],
      ),
    );
  }
}
