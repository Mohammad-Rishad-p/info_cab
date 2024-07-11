import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:info_cab_u/constant.dart';
import 'package:info_cab_u/functions/function_onWillPop.dart';

import '../../functions/function_exit.dart';

class UpcomingBookPage extends StatelessWidget {
  const UpcomingBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference bookings =
        FirebaseFirestore.instance.collection('bookings');

    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Upcoming Bookings'),
        ),
        body: const Center(child: Text('User not logged in')),
      );
    }

    String userId = user.uid;

    void cancelTrip(String docId) {
      bookings.doc(docId).delete();
    }

    Future<void> cancelConfirmAlert(BuildContext context, String docId) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cancel Booking?'),
            content: Text('Are you sure you want to cancel this booking?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // dismiss the dialog
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: textPrimColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  cancelTrip(docId);
                  Navigator.of(context).pop(); // dismiss the dialog
                },
                child: Text('Confirm', style: TextStyle(color: textPrimColor)),
              ),
            ],
          );
        },
      );
    }



    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upcoming Bookings', style: TextStyle()),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: bookings.where('userId', isEqualTo: userId).snapshots(),
          //apply condition for fetching current user's detail
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching bookings'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No upcoming bookings'));
            }

            var filteredDocs = snapshot.data!.docs.where((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return !data.containsKey('attended');
            }).toList();

            if (filteredDocs.isEmpty) {
              return const Center(child: Text('No upcoming bookings'));
            }
            return ListView.builder(
              itemCount: filteredDocs.length,
              itemBuilder: (context, index) {
                var booking = snapshot.data!.docs[index];
                String tripId = booking['tripId'] ?? 'N/A';
                String startPoint = booking['startPoint'] ?? 'N/A';
                String endPoint = booking['endPoint'] ?? 'N/A';
                String date = booking['tripDate'] ?? 'N/A';

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: textPrimColor,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red),
                          SizedBox(width: 8.0),
                          Text(
                            'From: $startPoint',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.flag, color: Colors.green),
                          SizedBox(width: 8.0),
                          Text(
                            'To: $endPoint',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue),
                          SizedBox(width: 8.0),
                          Text(
                            'Date: $date',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                                onPressed: () {
                                  cancelConfirmAlert(context, booking.id);
                                },
                                child: const Text(
                                  'Cancel Trip',
                                  style: TextStyle(color: textPrimColor),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:info_cab_u/constant.dart';
// import 'package:info_cab_u/functions/function_onWillPop.dart';
//
// import '../../functions/function_exit.dart';
//
// class UpcomingBookPage extends StatelessWidget {
//   const UpcomingBookPage({Key? key});
//
//   @override
//   Widget build(BuildContext context) {
//     final CollectionReference bookings =
//     FirebaseFirestore.instance.collection('bookings');
//
//     final FirebaseAuth auth = FirebaseAuth.instance;
//     User? user = auth.currentUser;
//
//     if (user == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Upcoming Bookings'),
//         ),
//         body: const Center(child: Text('User not logged in')),
//       );
//     }
//
//     String userId = user.uid;
//
//     return WillPopScope(
//       onWillPop: () => onWillPop(context),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Upcoming Bookings',
//             style: TextStyle(),
//           ),
//           automaticallyImplyLeading: false,
//           centerTitle: true,
//         ),
//         body: StreamBuilder(
//           stream: bookings.where('userId', isEqualTo: userId).snapshots(),
//           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (snapshot.hasError) {
//               return const Center(child: Text('Error fetching bookings'));
//             }
//
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Center(child: Text('No upcoming bookings'));
//             }
//
//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 var booking = snapshot.data!.docs[index];
//                 String tripId = booking['tripId'] ?? 'N/A';
//                 String startPoint = booking['startPoint'] ?? 'N/A';
//                 String endPoint = booking['endPoint'] ?? 'N/A';
//                 String date = booking['tripDate'] ?? 'N/A';
//                 bool tripCompleted = booking['attended'] ?? false; // Check if attended
//
//                 return Container(
//                   margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                   padding: EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                     color: textPrimColor,
//                     borderRadius: BorderRadius.circular(15.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.location_on, color: Colors.red),
//                           SizedBox(width: 8.0),
//                           Text(
//                             'From: $startPoint',
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8.0),
//                       Row(
//                         children: [
//                           Icon(Icons.flag, color: Colors.green),
//                           SizedBox(width: 8.0),
//                           Text(
//                             'To: $endPoint',
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8.0),
//                       Row(
//                         children: [
//                           Icon(Icons.calendar_today, color: Colors.blue),
//                           SizedBox(width: 8.0),
//                           Text(
//                             'Date: $date',
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 250,
//                             child: ElevatedButton(
//                               onPressed: tripCompleted
//                                   ? null
//                                   : () {
//                                 // Handle cancel trip logic
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: tripCompleted
//                                     ? Colors.grey // Change button color if completed
//                                     : textPrimColor,
//                               ),
//                               child: Text(
//                                 tripCompleted ? 'Trip Completed' : 'Cancel Trip',
//                                 style: TextStyle(
//                                   color: tripCompleted ? Colors.black : Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
