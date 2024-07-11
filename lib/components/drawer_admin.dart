import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/components/round_image_widget.dart';
import 'package:info_cab_u/constant.dart';

class DrawerAdmin extends StatefulWidget {
  DrawerAdmin({super.key});

  @override
  State<DrawerAdmin> createState() => _DrawerAdminState();
}

class _DrawerAdminState extends State<DrawerAdmin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout?'),
          content: Text('Are you sure to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // dismiss the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: textSecColor,
              ),
              title: const Text('Logout'),
              onTap: () {
                showDeleteConfirmationDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history_rounded,color: textSecColor,),
              title: Text('View All Trips'),
              onTap: (){
                Navigator.pushNamed(context, '/history');
              },
            )
          ],
        ),
      ),
    );
  }
}
