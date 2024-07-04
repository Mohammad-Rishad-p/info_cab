import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/components/round_image_widget.dart';

class DrawerAdmin extends StatelessWidget {
  const DrawerAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //image in menu
            // const RoundImage(
            //     src:
            //         'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=600',
            //     radius: 90),

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
              leading: Icon(Icons.business),
              title: Text('Company'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 15.0),
            // Cab Users
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Users'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 15.0),
            // driver profile in menu
            ListTile(
              leading: Icon(Icons.taxi_alert_sharp),
              title: Text('Drivers'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            //cab stops
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Stops'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            //vehicles
            ListTile(
              leading: Icon(Icons.local_taxi),
              title: Text('Vehicles'),
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
              onTap: () async {
                await _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
            const SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }
}
