import 'package:flutter/material.dart';
import 'package:info_cab_u/pages/admin/add_company_page.dart';
import 'package:info_cab_u/constant.dart';
import 'package:info_cab_u/pages/admin/add_company_page.dart';
import 'package:info_cab_u/pages/admin/add_vehicle_page.dart';
import 'package:info_cab_u/pages/admin/add_stop.dart';
import 'package:info_cab_u/pages/admin/today_attendance.dart';
import 'package:info_cab_u/pages/admin/users_listing_page.dart';
import 'package:info_cab_u/pages/user/dashboard_page.dart';
import 'package:info_cab_u/pages/user/home_page.dart';
import 'package:info_cab_u/pages/user/login_page.dart';
import 'package:info_cab_u/pages/user/user_profile_page.dart';
import 'package:info_cab_u/pages/user/trips_page.dart';
import 'package:info_cab_u/pages/user/user_register_page.dart';
import 'package:info_cab_u/pages/user/otp_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/attendance',
      routes: {
        '/': (context) => HomePage(),
//         '/register': (context) => UserRegisterPage(),
        '/otppage': (context) => OtpPage(),
        '/trips': (context) => TripsPage(),
        '/profile': (context) => UserProfilePage(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage(),
        '/add_vehicle': (context) =>AddVehiclePage(),
        '/addstop': (context) => AddPickUpPointPage(),
        '/userslist': (context) => UsersListingPage(),
        '/attendance': (context) => UserAttendance()
        '/home':(context) => HomePage(),
        '/user_register':(context) => UserRegisterPage(),
        '/user_profile':(context) => UserProfilePage(),
        '/addcompany':(context) => AddCompanyPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: textPrimColor),
        useMaterial3: true,
      ),
    );
  }
}
