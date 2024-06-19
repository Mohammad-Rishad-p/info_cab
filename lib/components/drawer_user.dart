import 'package:flutter/material.dart';
import 'package:info_cab_u/components/round_image_widget.dart';

class DrawerUser extends StatelessWidget {
  const DrawerUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //image in menu
            const RoundImage(
                src:
                    'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=600',
                radius: 90),
            const SizedBox(height: 32.0),
            // trips in menu
            ListTile(
              leading: Icon(Icons.local_taxi),
              title: Text('Trips'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            //payments in menu
            const SizedBox(height: 15.0),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Payments'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 15.0),
            // driver profile in menu
            ListTile(
              leading: Icon(Icons.taxi_alert_sharp),
              title: Text('Driver Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // about in in menu
            const SizedBox(height: 15.0),
            ListTile(
              leading: Icon(Icons.warning_amber_outlined),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            //logout
            const SizedBox(height: 15.0),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 25.0),
          ],
        ),
      );
  }
}