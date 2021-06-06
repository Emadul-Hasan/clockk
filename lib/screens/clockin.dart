import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/custom_component/inputfield.dart';
import 'package:flutter/material.dart';

class ClockIn extends StatefulWidget {
  static const id = "ClockIn";
  @override
  _ClockInState createState() => _ClockInState();
}

class _ClockInState extends State<ClockIn> {
  List<String> DropDownItems = ["Azhar", "Beauty", "Mujib"];
  String valueChoosen;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("Clock in")),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 0.0, bottom: 0.0),
                child: Container(
                  width: 250.0,
                  height: 40,
                  padding: EdgeInsets.only(right: 15.0, left: 18.0),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.lightBlueAccent, width: 1),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: DropdownButton(
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30.0,
                    isExpanded: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    hint: Text("User Name"),
                    value: valueChoosen,
                    onChanged: (newvalue) {
                      setState(() {
                        valueChoosen = newvalue;
                        print(newvalue);
                      });
                    },
                    items: DropDownItems.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Inputfield(
                obscuretext: true,
                margin: 10.0,
                hintText: 'Enter Your Password',
                prefixicon: Icon(
                  Icons.lock,
                  color: Colors.lightBlueAccent,
                ),
                function: (value) {
                  print(value);
                },
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlueAccent,
                    padding: EdgeInsets.fromLTRB(100.0, 10.0, 100.0, 10.0),
                  ),
                  child: Text("Clock in"),
                  onPressed: () {
                    print("Pressed");
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
