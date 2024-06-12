import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            
          ),
          ),
    );
  }
}
