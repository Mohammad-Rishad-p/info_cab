import 'package:flutter/material.dart';

class NText extends StatelessWidget {
  const NText({super.key, required this.content,required this.textColor});

  final String content;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(content, style: TextStyle(color: textColor, fontSize: 20,),);
  }
}