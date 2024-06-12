import 'package:flutter/material.dart';

class NText extends StatelessWidget {
  const NText({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Text(content, style: TextStyle(color: Colors.black, fontSize: 20,),);
  }
}