import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:info_cab_u/basic_widgets/normal_text_widget.dart';
import 'package:info_cab_u/components/container_card_widget.dart';
import 'package:info_cab_u/components/round_image_widget.dart';
import 'package:info_cab_u/components/bottom_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            BigCard(),
          ],
    ),
    bottomNavigationBar: BottomNavigation(),
    );
  }
}
