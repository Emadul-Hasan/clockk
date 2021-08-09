import 'package:connectivity/connectivity.dart';

class CheckConnectivity {
  Future<String> checkingConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      return "Please turn on connectivity to use this app";
    } else {
      return null;
    }
  }
}
