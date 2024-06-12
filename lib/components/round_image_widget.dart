import 'package:flutter/material.dart';

class RoundImage extends StatelessWidget {
  const RoundImage({super.key, required this.src});

  final String src;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50.0,
      backgroundImage: NetworkImage(src),
      backgroundColor: Colors.transparent,
      
    );
  }
}