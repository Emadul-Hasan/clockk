import 'package:clockk/custom_component/customappbar.dart';
import 'package:clockk/custom_component/drawerCustomList.dart';
import 'package:clockk/models/AlertModel.dart';
import 'package:clockk/models/connectivityCheck.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'notification.dart';

class MoreFeatures extends StatefulWidget {
  static const id = 'moreFeature';

  @override
  _MoreFeaturesState createState() => _MoreFeaturesState();
}

class _MoreFeaturesState extends State<MoreFeatures> {
  AlertMessage alert = AlertMessage();

  CheckConnectivity _connectivityCheck = CheckConnectivity();

  void checkConnection() async {
    String resultString = await _connectivityCheck.checkingConnection();
    if (resultString != null) {
      alert.messageAlert(context, "Error", MdiIcons.close,
          'Please turn on connectivity to use this app', Colors.red);
    }
  }

  @override
  void initState() {
    checkConnection();
    super.initState();
  }

  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomList(),
      appBar: CustomAppBar(Text("More Feature"), () {
        Navigator.pushReplacementNamed(context, Notifications.id);
      }),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white,
              minHeight: 5.0,
              color: Colors.amber,
            ),
          ),
          Expanded(
            flex: 95,
            child: WebView(
              initialUrl: 'https://clockk.in',
              javascriptMode: JavascriptMode.unrestricted,
              onProgress: (value) {
                setState(() {
                  progress = value / 100.0;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
