import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Notifications extends StatefulWidget {
  static const id = "Notifications";
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Future<void> getNotificationData() async {
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/notification";
    var url = Uri.parse(webUrl);
    print(webUrl);
    try {
      http.Response response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      });

      if (response.statusCode == 200) {
        setState(() {
          showSpinner = false;

        var data = jsonDecode(response.body);
        print(data);
        var value = data['data'];
        print(value);
        for(var item in value){

          notifications.add(item['title']);
        }
        });
        }
       else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }



  bool showSpinner = true;

  @override
  void initState() {
    getNotificationData();
    super.initState();
  }
  List<String> notifications = [];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Notifications"),(){
        Navigator.pushReplacementNamed(context, Notifications.id);
      }),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {


            return  Container(
              margin: EdgeInsets.only(left: 5.0,right: 5.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(left:4.0,right: 4.0, top: 10.0,bottom: 10.0),
                  child: ListTile(
                    minLeadingWidth: 2.0,
                    horizontalTitleGap: 5.0,
                    leading: Icon(MdiIcons.alarm,color: Colors.orange,size: 25.0,),
                    title:Text(notifications[index],style: TextStyle(fontSize: 14.0),) ,
                  ),
                )),
            );
          },
          itemCount: notifications.length,
        ),
      ),
    );
  }
}


