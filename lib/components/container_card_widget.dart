import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';

class BigCard extends StatelessWidget {
  const BigCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      color: buttonColor,
    );
  }
}