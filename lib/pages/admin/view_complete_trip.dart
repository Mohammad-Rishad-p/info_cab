import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constant.dart';

class ViewCompleteTrip extends StatefulWidget {
  const ViewCompleteTrip({super.key});

  @override
  State<ViewCompleteTrip> createState() => _ViewCompleteTripState();
}

class _ViewCompleteTripState extends State<ViewCompleteTrip> {

  final CollectionReference trips =
  FirebaseFirestore.instance.collection('trips');
  late User? currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
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

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot tripSnap = snapshot.data!.docs[index];
                final tripData = tripSnap.data() as Map<String, dynamic>;

                String formattedDate;
                if (tripData['date'] is Timestamp) {  // timestap format aanengil conert to dateformat
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
                        '/attendance',
                        arguments: {
                          'tripId': tripSnap.id,
                          'date': tripData['date'],
                          'start point': tripData['start point'],
                          'end point': tripData['end point'],
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
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        // margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        padding: const EdgeInsets.all(16.0),
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
                                      const SizedBox(height: 4.0),
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
                                const SizedBox(width: 12.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.event_seat,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          tripData['seat'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
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
    );
  }
}
