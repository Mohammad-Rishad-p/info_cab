import 'package:flutter/services.dart';

Future<bool> onWillPop() async {
  // Exit the app
  SystemNavigator.pop();
  return Future.value(false);
}