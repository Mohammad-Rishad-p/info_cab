import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';
import 'package:info_cab_u/pages/user/profile_page.dart';
import 'package:info_cab_u/pages/user/trips_page.dart';

import 'home_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var _currentIndex = 0;

  final _bodyPages = const <Widget>[
    HomePage(),
    TripsPage(),
    ProfilePage(),
  ];

  final _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.location_on_outlined),
      label: 'Trips',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  void _onItemClick(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyPages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _bottomNavBarItems,
        onTap: _onItemClick,
        selectedItemColor: textPrimColor,
        unselectedItemColor: textSecColor,
      ),
    );
  }
}
