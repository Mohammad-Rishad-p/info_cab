import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';
import 'package:info_cab_u/pages/admin/add_vehicle_page.dart';
import 'package:info_cab_u/pages/user/dashboard_page.dart';
import 'package:info_cab_u/pages/user/home_page.dart';
import 'package:info_cab_u/pages/user/login_page.dart';
import 'package:info_cab_u/pages/user/user_profile_page.dart';
import 'package:info_cab_u/pages/user/trips_page.dart';
import 'package:info_cab_u/pages/user/user_register_page.dart';
import 'package:info_cab_u/pages/user/otp_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD

      initialRoute: '/add_vehicle',
=======
      initialRoute: '/register',
>>>>>>> 9cc9913e5e2a34a2cd6223d0195458c6592d717f
      routes: {
        '/': (context) => HomePage(),
        '/register': (context) => UserRegisterPage(),
        '/otppage': (context) => OtpPage(),
        '/trips': (context) => TripsPage(),
        '/profile': (context) => ProfilePage(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage(),
        '/add_vehicle': (context) =>AddVehiclePage()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: textPrimColor),
        useMaterial3: true,
      ),
    );
  }
}
