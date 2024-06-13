import 'package:flutter/material.dart';
import 'package:info_cab_u/pages_user/dashboard_page.dart';
import 'package:info_cab_u/pages_user/home_page.dart';
import 'package:info_cab_u/pages_user/login_page.dart';
import 'package:info_cab_u/pages_user/user_profile_page.dart';
import 'package:info_cab_u/pages_user/trips_page.dart';
import 'package:info_cab_u/pages_user/user_register_page.dart';
import 'package:info_cab_u/pages_user/otp_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/login',
      routes: {
        '/': (context) => HomePage(),
        '/register': (context) => UserRegisterPage(),
        '/otppage': (context) => OtpPage(),
        '/trips': (context) => TripsPage(),
        '/profile': (context) => ProfilePage(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage()
      },
    );
  }
}
