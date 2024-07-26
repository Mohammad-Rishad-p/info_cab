import 'package:flutter/material.dart';
import 'package:info_cab_u/pages/admin/add_company_page.dart';
import 'package:info_cab_u/constant.dart';
import 'package:info_cab_u/pages/admin/add_company_page.dart';
import 'package:info_cab_u/pages/admin/add_driver_page.dart';
import 'package:info_cab_u/pages/admin/add_trips_page.dart';
import 'package:info_cab_u/pages/admin/add_vehicle_page.dart';
import 'package:info_cab_u/pages/admin/add_stop_page.dart';
import 'package:info_cab_u/pages/admin/admin_dashboard_page.dart';
import 'package:info_cab_u/pages/admin/admin_login_page.dart';
import 'package:info_cab_u/pages/admin/driver_list_page.dart';
import 'package:info_cab_u/pages/admin/user_attendence_page.dart';

// import 'package:info_cab_u/pages/admin/add_stop.dart';
import 'package:info_cab_u/pages/admin/trips_list_page_admin.dart'; // import 'package:info_cab_u/pages/admin/today_attendance.dart';
import 'package:info_cab_u/pages/admin/users_list_page.dart';
import 'package:info_cab_u/pages/admin/vehicle_list_page.dart';
import 'package:info_cab_u/pages/admin/view_complete_trip.dart';
import 'package:info_cab_u/pages/driver/driver_login_page.dart';
import 'package:info_cab_u/pages/driver/drivers_passengers_list.dart';
import 'package:info_cab_u/pages/driver/view_trip_driver.dart';
import 'package:info_cab_u/pages/role_selection_page.dart';
import 'package:info_cab_u/pages/user/edit_profile_page.dart';
import 'package:info_cab_u/pages/user/upcoming_book_page.dart';
import 'package:info_cab_u/pages/user/view_trips.dart';
import 'package:info_cab_u/pages/user/dashboard_page.dart';
import 'package:info_cab_u/pages/user/home_page.dart';
import 'package:info_cab_u/pages/user/login_page.dart';
import 'package:info_cab_u/splash_page.dart';
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
      initialRoute: '/splash',
      routes: {
//         '/register': (context) => UserRegisterPage(),
        '/splash': (context) => SplashPage(),
        '/otp': (context) => OTPPage(),
        '/trips': (context) => TripsPage(),
        '/login': (context) => LoginPage(),
        '/adminLogin': (context) => AdminLoginPage(),
        '/dashboard': (context) => DashboardPage(),
        '/add_vehicle': (context) => AddVehiclePage(),
        '/addStop': (context) => AddPickUpPointPage(),
        '/users_list': (context) => UsersListPage(),
        '/attendance': (context) => UserAttendancePage(),
        '/home': (context) => HomePage(),
        '/user_register': (context) => UserRegisterPage(
              uid: '',
            ),
        '/user_profile': (context) => UserProfilePage(),
        '/driver_list': (context) => DriverListPage(),
        '/add_driver': (context) => AddDriverPage(),
        '/addCompany': (context) => AddCompanyPage(),
        '/addTrips': (context) => AddTripsPage(),
        '/viewTrips': (context) => ViewTripsPage(),
        '/viewTripsAdmin': (context) => TripsListPageAdmin(),
        // '/drivers_list': (context) => DriversListingPage(),
        '/upcoming_book': (context) => UpcomingBookPage(),
        '/listVehicle': (context) => VehicleListPage(),
        '/adminDashboard': (context) => AdminDashboardPage(),
        '/history': (context) => ViewCompleteTrip(),
        '/editProfile': (context) => EditProfilePage(userId: ''),

        '/roleSelection': (context) => RoleSelectionPage(),

        //driver

        '/driverLogin': (context) => DriverLoginPage(),
        '/driverViewTrip': (context) => ViewTripDriver(),
        '/passList': (context) => PassengersListPage()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: textPrimColor),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(backgroundColor: Colors.white),
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
    );
  }
}
