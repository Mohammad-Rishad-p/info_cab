import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:info_cab_u/components/drawer_user.dart';
import 'package:info_cab_u/constant.dart';
import 'package:info_cab_u/functions/function_exit.dart';

import '../../functions/function_onWillPop.dart';

class ViewTripsPage extends StatefulWidget {
  const ViewTripsPage({Key? key}) : super(key: key);

  @override
  _ViewTripsPageState createState() => _ViewTripsPageState();
}

class _ViewTripsPageState extends State<ViewTripsPage> {
  final CollectionReference trips =
  FirebaseFirestore.instance.collection('trips');
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('View Trips'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),

        // drawer: DrawerUser(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
          child: StreamBuilder(
            stream: trips.orderBy('date',descending: true).snapshots(), // Ordering by date
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('An error occurred'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No trips available'));
              }

              final List<DocumentSnapshot> docs = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return !data.containsKey('status');
              }).toList();

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot tripSnap = docs[index];
                  final tripData = tripSnap.data() as Map<String, dynamic>;

                  // Handle both Timestamp and String for date
                  String formattedDate;
                  if (tripData['date'] is Timestamp) {
                    formattedDate = DateFormat.yMMMd()
                        .format((tripData['date'] as Timestamp).toDate());
                  } else if (tripData['date'] is String) {
                    formattedDate = tripData['date'];
                  } else {
                    formattedDate = 'Unknown date';
                  }



                  return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/home',
                          arguments: {
                            'tripId': tripSnap.id,
                            'date': tripSnap['date'],
                            'start point': tripSnap['start point'],
                            'end point': tripSnap['end point'],
                            'seat': tripSnap['seat']
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: textPrimColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          // margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tripData['vehicle detail'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4.0),
                                        Text(
                                          '${tripData['start point']} to ${tripData['end point']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.event_seat,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          SizedBox(width: 4.0),
                                          Text(
                                            tripData['seat'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:info_cab_u/components/drawer_user.dart';
// import 'package:info_cab_u/constant.dart';
// import 'package:info_cab_u/functions/function_exit.dart';
//
// import '../../functions/function_onWillPop.dart';
//
// class ViewTripsPage extends StatefulWidget {
//   const ViewTripsPage({Key? key}) : super(key: key);
//
//   @override
//   _ViewTripsPageState createState() => _ViewTripsPageState();
// }
//
// class _ViewTripsPageState extends State<ViewTripsPage> {
//   final CollectionReference trips = FirebaseFirestore.instance.collection('trips');
//   late User? currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     currentUser = FirebaseAuth.instance.currentUser;
//   }
//
//   Future<int> getBookingsCount(String tripId) async {
//     QuerySnapshot bookingsSnapshot = await trips.doc(tripId).collection('bookings').get();
//     return bookingsSnapshot.docs.length;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => onWillPop(context),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('View Trips'),
//           centerTitle: true,
//         ),
//         drawer: DrawerUser(),
//         body: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
//           child: StreamBuilder(
//             stream: trips.orderBy('date', descending: true).snapshots(), // Ordering by date
//             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               if (snapshot.hasError) {
//                 return const Center(child: Text('An error occurred'));
//               }
//
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return const Center(child: Text('No trips available'));
//               }
//
//               return ListView.builder(
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (context, index) {
//                   final DocumentSnapshot tripSnap = snapshot.data!.docs[index];
//                   final tripData = tripSnap.data() as Map<String, dynamic>;
//
//                   // Handle both Timestamp and String for date
//                   String formattedDate;
//                   if (tripData['date'] is Timestamp) {
//                     formattedDate = DateFormat.yMMMd().format((tripData['date'] as Timestamp).toDate());
//                   } else if (tripData['date'] is String) {
//                     formattedDate = tripData['date'];
//                   } else {
//                     formattedDate = 'Unknown date';
//                   }
//
//                   return FutureBuilder<int>(
//                     future: getBookingsCount(tripSnap.id),
//                     builder: (context, bookingsSnapshot) {
//                       if (bookingsSnapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//
//                       if (bookingsSnapshot.hasError) {
//                         return const Center(child: Text('An error occurred while fetching bookings'));
//                       }
//
//                       int totalSeats = int.parse(tripData['seat']);
//                       int bookedSeats = bookingsSnapshot.data ?? 0;
//                       int remainingSeats = totalSeats - bookedSeats;
//
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.pushNamed(
//                             context,
//                             '/home',
//                             arguments: {
//                               'tripId': tripSnap.id,
//                               'date': tripSnap['date'],
//                               'start point': tripSnap['start point'],
//                               'end point': tripSnap['end point'],
//                               'seat': tripSnap['seat']
//                             },
//                           );
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: textPrimColor,
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.3),
//                                   spreadRadius: 2,
//                                   blurRadius: 6,
//                                   offset: Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             padding: EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             tripData['vehicle detail'],
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 18,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                           SizedBox(height: 4.0),
//                                           Text(
//                                             '${tripData['start point']} to ${tripData['end point']}',
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(width: 12.0),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.end,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Icon(
//                                               Icons.event_seat,
//                                               color: Colors.white,
//                                               size: 18,
//                                             ),
//                                             SizedBox(width: 4.0),
//                                             Text(
//                                               'Remaining: $remainingSeats',
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(height: 8.0),
//                                         Text(
//                                           formattedDate,
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }