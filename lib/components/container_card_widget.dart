import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: buttonColor,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 229, 228, 228),
                blurRadius: 10,
                spreadRadius: 15)
          ]),
    );
  }
}
