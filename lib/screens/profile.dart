import 'dart:convert';
import 'dart:io';

import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/custom_component/inputfield.dart';
import 'package:clockk/models/AlertModel.dart';
import 'package:clockk/models/connectivityCheck.dart';
import 'package:clockk/screens/timesheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'dashboard.dart';
import 'login.dart';
import 'notification.dart';

class ProfileScreen extends StatefulWidget {
  static String id = "ProfileScreen";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Profile"), () {
        Navigator.pushNamed(context, Notifications.id);
      }),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String name = 'N/A';
  String email = 'N/A';
  var id;
  String company = 'N/A';
  String address = 'N/A';
  var phone;
  String oldpass = '';
  String newpass = '';
  String confpass = '';
  bool showProfSpinner = true;
  AlertMessage alert = AlertMessage();

  Future<void> getProfileData() async {
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/my_profile";
    var url = Uri.parse(webUrl);

    try {
      http.Response response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        var value = data['data'];
        name = value['name'];
        email = value['email'];
        id = value['id'];
        company = value['company_name'];
        phone = value['phone'];
        address = value['address'];
        setState(() {
          showProfSpinner = false;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  _onAlertPasswordChange(context) {
    Alert(
        context: context,
        title: "Change Password",
        content: Column(
          children: <Widget>[
            Inputfield(
              obscuretext: true,
              margin: 10.0,
              hintText: 'Enter old password',
              prefixicon: Icon(Icons.lock),
              function: (value) {
                oldpass = value;
              },
            ),
            Inputfield(
              obscuretext: true,
              margin: 10.0,
              hintText: 'Enter new password',
              prefixicon: Icon(Icons.lock),
              function: (value) {
                newpass = value;
              },
            ),
            Inputfield(
              obscuretext: true,
              margin: 10.0,
              hintText: 'Confirm new password',
              prefixicon: Icon(Icons.lock),
              function: (value) {
                confpass = value;
              },
            ),
          ],
        ),
        buttons: [
          DialogButton(
            width: 100.0,
            color: Colors.lightBlueAccent,
            onPressed: () async {
              var token = await FlutterSession().get('token');
              String webUrl =
                  "https://clockk.in/api/password_change?old_password=$oldpass&password=$newpass&confirm_password=$confpass";
              var url = Uri.parse(webUrl);

              try {
                http.Response response = await http.post(url, headers: {
                  'Content-type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': token
                });

                if (response.statusCode == 200) {

                  Navigator.pop(context);
                  alert.messageAlert(context, 'Status', MdiIcons.check,
                      "Success", Colors.green);
                } else {
                  Navigator.pop(context);
                  alert.messageAlert(context, 'Status', MdiIcons.close,
                      'failed try again', Colors.red);
                  print(response.statusCode);
                }
              } catch (e) {
                print(e);
                Navigator.pop(context);
              }
            },
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        ]).show();
  }

  _onAlertProfileChange(context) {
    Alert(
        context: context,
        title: "Change Profile",
        content: Column(
          children: <Widget>[
            Inputfield(
              obscuretext: false,
              margin: 10.0,
              hintText: '${name == 'N/A' ? "Enter your name" : name}',
              prefixicon: Icon(MdiIcons.accountOutline),
              function: (value) {
                if (value != null) {
                  name = value;
                } else {
                  name = name;
                }
              },
            ),
            Inputfield(
              obscuretext: false,
              margin: 10.0,
              hintText: '${phone == 'N/A' ? "Enter your contact" : phone}',
              prefixicon: Icon(MdiIcons.phoneOutline),
              function: (value) {
                if (value != null) {
                  phone = value;
                } else {
                  phone = phone;
                }
              },
            ),
            Inputfield(
              obscuretext: false,
              margin: 10.0,
              hintText: '${address == null ? "Enter your address" : address}',
              prefixicon: Icon(MdiIcons.mapMarkerOutline),
              function: (value) {
                if (value != null) {
                  address = value;
                } else {
                  address = address;
                }
              },
            ),
          ],
        ),
        buttons: [
          DialogButton(
            width: 100.0,
            color: Colors.lightBlueAccent,
            onPressed: () async {
              var token = await FlutterSession().get('token');


              String webUrl =
                  "https://clockk.in/api/profile_update?name=$name&phone=$phone&address=$address";
              var url = Uri.parse(webUrl);


              try {
                http.Response response = await http.post(url, headers: {
                  'Content-type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': token
                });

                if (response.statusCode == 200) {

                  Navigator.pop(context);
                  alert.messageAlert(context, 'Status', MdiIcons.check,
                      "Success", Colors.green);
                } else {
                  Navigator.pop(context);
                  alert.messageAlert(context, 'Status', MdiIcons.close,
                      'failed try again', Colors.red);
                  print(response.statusCode);
                }
              } catch (e) {
                print(e);
                Navigator.pop(context);
              }
            },
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        ]).show();
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
    getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProfSpinner,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfilePicture(
              showSpinner: showProfSpinner,
            ),
            SizedBox(height: 20),
            ProfileMenu(
                text: "Dashboard",
                icon: MdiIcons.dotsGrid,
                press: () {
                  Navigator.pushNamed(context, DashBoard.id);
                }),
            ProfileMenu(
              text: "Time sheet",
              icon: MdiIcons.calendarOutline,
              press: () {
                Navigator.pushNamed(context, TimeSheet.id);
              },
            ),
            ProfileMenu(
              text: "Change password",
              icon: MdiIcons.onepassword,
              icon2: Icons.edit,
              press: () {
                _onAlertPasswordChange(context);
              },
            ),
            ProfileMenu(
              text: "Change profile",
              icon: MdiIcons.accountOutline,
              icon2: Icons.edit,
              press: () {
                _onAlertProfileChange(context);
              },
            ),
            ProfileMenu(
              text: "Log Out",
              icon: MdiIcons.logout,
              press: () async {
                var token = await FlutterSession().get('token');
                String webUrl = "https://clockk.in/api/logout";
                var url = Uri.parse(webUrl);

                try {
                  http.Response response = await http.get(url, headers: {
                    'Content-type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': token
                  });

                  if (response.statusCode == 200) {

                    await FlutterSession().set('token', '');
                    Navigator.pushReplacementNamed(context, Login.id);
                  } else {
                    print(response.statusCode);
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu(
      {Key key,
      @required this.text,
      @required this.icon,
      this.press,
      this.icon2})
      : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback press;
  final IconData icon2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFF5F6F9),
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextButton(
          onPressed: press,
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Icon(
                icon2,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePicture extends StatefulWidget {
  ProfilePicture({this.showSpinner});
  bool showSpinner;
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  Dio dio = new Dio();
  var image;
  File imagePicked;
  PickedFile pickedImage;
  Future<void> getProfileData() async {
    var token = await FlutterSession().get('token');
    String webUrl = "https://clockk.in/api/my_profile";
    var url = Uri.parse(webUrl);

    try {
      http.Response response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        var value = data['data'];
        setState(() {
          image = value['image'];
        });
        await FlutterSession().set('image', image);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var getData;
    setState(() {
      getData = FlutterSession().get('image');

    });

    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          FutureBuilder(
              future: getData,
              builder: (context, snapshot) {
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 28.0,
                  backgroundImage: snapshot.hasData
                      ? NetworkImage(snapshot.data)
                      : AssetImage('images/logo.png'),
                  // child: Image(
                  //   image: AssetImage('images/prof.png'),
                  // ),
                );
              }),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 50,
              width: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextButton(
                  onPressed: () async {
                    pickedImage = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        imagePicked = File(pickedImage.path);
                        widget.showSpinner = true;
                      });
                    }
                    try {
                      String fileName = imagePicked.path.split('/').last;

                      FormData fromdata = new FormData.fromMap({
                        'image': await MultipartFile.fromFile(imagePicked.path,
                            filename: fileName,
                            contentType: MediaType('image', 'png')),
                        'type': 'image/png'
                      });

                      var token = await FlutterSession().get('token');
                      String webUrl =
                          "https://clockk.in/api/change_profile_picture?image=$fileName";
                      var url = Uri.parse(webUrl);

                      try {
                        Response response = await dio.post(webUrl,
                            data: fromdata,
                            options: Options(headers: {
                              'Content-type': 'application/json',
                              'Accept': 'application/json',
                              'Authorization': token
                            }));

                        if (response.statusCode == 200) {


                          setState(() {
                            getProfileData();
                            widget.showSpinner = false;
                          });
                        } else {
                          print(response.statusCode);
                        }
                      } catch (e) {
                        print(e);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Icon(
                    MdiIcons.camera,
                    size: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
