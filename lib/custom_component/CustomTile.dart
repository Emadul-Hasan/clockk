import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String menuTitle;
  final IconData icon;
  final Function action;
  CustomListTile(
      {@required this.menuTitle, @required this.icon, @required this.action});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        menuTitle,
        style: TextStyle(
            color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w400),
      ),
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black12, spreadRadius: 2)
          ],
        ),
        child: CircleAvatar(
          child: Icon(
            icon,
            color: Colors.black,
            size: 25.0,
          ),
          backgroundColor: Colors.white,
        ),
      ),
      onTap: action,
    );
  }
}
