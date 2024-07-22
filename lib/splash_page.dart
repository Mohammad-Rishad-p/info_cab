import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:info_cab_u/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/user/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => _checkAuthStatus());
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuth = prefs.getBool('isAuth') ?? false;
    final isAuthAdmin = prefs.getBool('isAuthAdmin') ?? false;
    final isAuthDriver = prefs.getBool('isAuthDriver') ?? false;

    if (isAuth) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (route) => false);
    } else if (isAuthAdmin) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/adminDashboard', (route) => false);
    } else if (isAuthDriver) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/viewTripsDriver', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: HText(content: 'InfoCab', textColor: textPrimColor),
      ),
    );
  }
}
