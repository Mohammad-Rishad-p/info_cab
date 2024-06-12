import 'package:flutter/material.dart';

class HText extends StatelessWidget {
  const HText({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Text(content, style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w800),);
  }
}