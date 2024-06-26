import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/components/drawer_user.dart';
import 'package:info_cab_u/constant.dart';
import 'package:info_cab_u/functions/function_exit.dart';
import 'package:intl/intl.dart';

class ViewTripsPage extends StatefulWidget {
  const ViewTripsPage({super.key});

  @override
  _ViewTripsPageState createState() => _ViewTripsPageState();
}

class _ViewTripsPageState extends State<ViewTripsPage> {
  final CollectionReference trips = FirebaseFirestore.instance.collection('trips');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('View Trips'),
          centerTitle: true,
          // automaticallyImplyLeading: false,
        ),
        drawer: DrawerUser(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder(
            stream: trips.snapshots(),
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

                  // Handle both Timestamp and String for date
                  String formattedDate;
                  if (tripData['date'] is Timestamp) {
                    formattedDate = DateFormat.yMMMd().format((tripData['date'] as Timestamp).toDate());
                  } else if (tripData['date'] is String) {
                    formattedDate = tripData['date'];
                  } else {
                    formattedDate = 'Unknown date';
                  }

                  return Card(
                    color: primaryColor,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/home',
                          arguments: {
                            'tripId': tripSnap.id,
                            'date': tripData['date'],
                            'start point': tripData['start point'],
                            'end point': tripData['end point'],
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  tripData['vehicle detail'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                const Spacer(),
                                Text(
                                  tripData['seat'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const Icon(Icons.event_seat),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tripData['start point'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.arrow_forward),
                                Text(tripData['end point']),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
