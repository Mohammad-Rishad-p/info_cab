// import 'package:flutter/material.dart';
//
// class CustomSnackBar extends StatelessWidget {
//   final String message;
//   final Duration duration;
//
//   const CustomSnackBar({
//     Key? key,
//     required this.message,
//     required this.duration,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // This widget doesn't return any UI element
//     // The SnackBar is shown when this widget is added to the widget tree
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           duration: duration,
//         ),
//       );
//     });
//
//     // Return an empty container since this widget doesn't have a UI
//     return Container();
//   }
// }


import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, Duration duration) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
    ),
  );
}
