import 'package:flutter/material.dart';
import 'package:info_cab_u/pages/home_page.dart';
import 'package:info_cab_u/pages/user_register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/register',
      routes: {
        '/': (context) => HomePage(),
        '/register': (context) => UserRegisterPage(),
      },
    );
  }
}
