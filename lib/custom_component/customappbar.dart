import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomAppBar extends AppBar {
  CustomAppBar(Widget title, Function _onPressed)
      : super(
          title: title,
          actions: [
            Container(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: Icon(MdiIcons.bellOutline),
                  onPressed: _onPressed,
                )),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Color(0xFF81B5D6), Color(0xFF868686)],
            )),
          ),
        );
}
