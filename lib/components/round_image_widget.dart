import 'package:flutter/material.dart';

class RoundImage extends StatelessWidget {
  const RoundImage({super.key, required this.src, required this.radius});

  final String src;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(src),
      backgroundColor: Colors.transparent,
    );
  }
}
