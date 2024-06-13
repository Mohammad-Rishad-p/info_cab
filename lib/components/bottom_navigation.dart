import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 1;

  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/trips');
        break;
      case 1:
        Navigator.pushNamed(context, '/');
        break;
      case 2:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: const <BottomNavigationBarItem> [
      BottomNavigationBarItem(
        icon: Icon(Icons.location_on),
        label: 'trips',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'profile',
      ),
    ],
    type: BottomNavigationBarType.shifting,
    iconSize: 40,
    currentIndex: _selectedIndex,
    onTap: _onTapItem,
    elevation: 5,
    fixedColor: textPrimColor,
    backgroundColor: Colors.red,
    unselectedItemColor: textSecColor,
    );
  }
}
