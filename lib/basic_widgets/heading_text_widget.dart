import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';

class HText extends StatelessWidget {
  const HText({super.key, required this.content, required this.textColor});

  final String content;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
          color: textColor, fontSize: 30, fontWeight: FontWeight.w800),
    );
  }
}


