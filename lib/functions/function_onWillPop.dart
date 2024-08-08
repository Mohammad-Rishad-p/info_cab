import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../basic_widgets/snack_bar_widget.dart'; // Import the SnackBar widget

DateTime? lastPressed;

Future<bool> onWillPop(BuildContext context) async {
  DateTime now = DateTime.now();
  if (lastPressed == null || now.difference(lastPressed!) > Duration(seconds: 2)) {
    lastPressed = now;
    showCustomSnackBar(context, 'Press back again to exit', Duration(seconds: 2));
    return Future.value(false);
  }
  return exitApp();
}

Future<bool> exitApp() async {
  SystemNavigator.pop();
  return Future.value(false);
}
