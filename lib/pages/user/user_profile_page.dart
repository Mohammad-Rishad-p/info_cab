// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:info_cab_u/components/round_image_widget.dart';
// import 'package:info_cab_u/constant.dart';
//
// class UserProfilePage extends StatelessWidget {
//   const UserProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         centerTitle: true,
//         backgroundColor: primaryColor,
//       ),
//       body: const Profile(),
//       backgroundColor: primaryColor,
//     );
//   }
// }
//
// class Profile extends StatefulWidget {
//   const Profile({super.key});
//
//   @override
//   State<Profile> createState() => _ProfileState();
// }
//
// class _ProfileState extends State<Profile> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//
//   final String name = " ";
//   final String company = " ";
//   final String phone = " ";
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: <Widget>[
//           Center(
//             child: Stack(
//               children: [
//                 const RoundImage(
//                     src:
//                         'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=600',
//                     radius: 50),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: CircleAvatar(
//                     backgroundColor: textPrimColor,
//                     radius: 20,
//                     child: IconButton(
//                       icon: const Icon(Icons.camera_alt),
//                       iconSize: 20.0, // Adjusted icon size
//                       color: primaryColor,
//                       onPressed: () {
//                         print('Icon Button Pressed');
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 50),
//           ListTile(
//             leading: Icon(Icons.person),
//             title: Text(
//               'Name',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(name, style: TextStyle(fontSize: 18.0)),
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.info),
//             title: Text(
//               'Company',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(company, style: TextStyle(fontSize: 18.0)),
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.phone),
//             title: Text(
//               'Phone',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(phone, style: TextStyle(fontSize: 18.0)),
//           ),
//         ],
//       ),
//     );
//   }
// }
