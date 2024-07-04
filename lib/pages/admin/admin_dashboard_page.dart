import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:info_cab_u/pages/admin/company_list_page.dart';
import 'package:info_cab_u/pages/admin/driver_list_page.dart';
import 'package:info_cab_u/pages/admin/users_list_page.dart';
import 'package:info_cab_u/pages/admin/vehicle_list_page.dart';
import 'package:info_cab_u/pages/admin/stops_list_page.dart';
import 'package:info_cab_u/pages/admin/trips_list_page_admin.dart';

import '../../constant.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {


    final _bodyPages = const <Widget>[
      TripsListPageAdmin(),
      UsersListPage(),
      StopsListPage(),
      DriverListPage(),
      CompanyListPage(),
      VehicleListPage()
    ];

    final bottomNavBarItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline_rounded),
        activeIcon: Icon(Icons.person),
        label: 'Users',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.place_outlined),
        activeIcon: Icon(Icons.place),
        label: 'Stops',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_pin_outlined),
        activeIcon: Icon(Icons.person_pin_sharp),
        label: 'Driver',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.apartment_outlined),
        activeIcon: Icon(Icons.apartment_rounded),
        label: 'Company',
      ),
      const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.car),
        activeIcon: Icon(CupertinoIcons.car),
        label: 'Vehicle',
      ),
    ];

    void _onItemClick(int value) {
      setState(() {
        _currentIndex = value;
      });
    }

    return Scaffold(
      body: _bodyPages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        currentIndex: _currentIndex,
        items: bottomNavBarItems,
        onTap: _onItemClick,
        selectedItemColor: textPrimColor,
        unselectedItemColor: textSecColor,
        selectedIconTheme: IconThemeData(size: 24), // Set size to avoid enlargement
        unselectedIconTheme: IconThemeData(size: 24), // Set size to match
        selectedLabelStyle: TextStyle(fontSize: 14), // Set the same size for selected label
        unselectedLabelStyle: TextStyle(fontSize: 14), // Set the same size for unselected label
        selectedFontSize: 14, // Set the same font size for selected
        unselectedFontSize: 14, // Set the same font size for unselected // Set size to match
      ),
    );
  }
}
