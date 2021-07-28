import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AlertMessage {
  messageAlert(
      context, String title, IconData icon, String message, Color color) {
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
                icon,
                color: color == null ? Colors.orange : color,
                size: 50.0,
              ),
              SizedBox(
                height: 3.0,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
              ),
            ],
          ),
        ),
        buttons: []).show();
  }
}
