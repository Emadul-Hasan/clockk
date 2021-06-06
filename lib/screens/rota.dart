import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class Rota extends StatefulWidget {
  static const id = "Rota";
  @override
  _RotaState createState() => _RotaState();
}

class _RotaState extends State<Rota> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Rota")),
      body: SfCalendar(
        view: CalendarView.week,
        firstDayOfWeek: 6,
        dataSource: MeetingDataSource(getAppointments()),
      ),
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = [];
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

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
