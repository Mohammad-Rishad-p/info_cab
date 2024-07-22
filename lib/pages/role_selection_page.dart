import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Job Junction',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: textPrimColor,
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoleSelectionCard(
                  role: 'Driver',
                  icon: Icons.percent_rounded,
                  onPressed: () {
                    Navigator.pushNamed(context, '/driverLogin');
                  },
                ),
                SizedBox(width: 20),
                RoleSelectionCard(
                  role: 'Admin',
                  icon: Icons.admin_panel_settings_rounded,
                  onPressed: () {
                    Navigator.pushNamed(context, '/adminLogin');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RoleSelectionCard extends StatelessWidget {
  final String role;
  final IconData icon;
  final VoidCallback onPressed;

  const RoleSelectionCard(
      {super.key,
      required this.role,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 160,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: textSecColor,
            ),
            SizedBox(height: 10),
            Text(
              role,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textSecColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
