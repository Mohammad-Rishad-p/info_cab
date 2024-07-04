import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../functions/function_onWillPop.dart';

class TripsListPageAdmin extends StatefulWidget {
  const TripsListPageAdmin({super.key});

  @override
  State<TripsListPageAdmin> createState() => _TripsListPageAdminState();
}

class _TripsListPageAdminState extends State<TripsListPageAdmin> {
  final CollectionReference trips =
      FirebaseFirestore.instance.collection('trips');
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String tripId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this trip?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteTrip(tripId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTrip(String tripId) async {
    try {
      await trips.doc(tripId).delete(); //doc(tripId) means doc id
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trip deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete trip: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cabs'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Create Trips',
          onPressed: () {
            Navigator.pushNamed(context, '/addTrips');
          },
          child: const Icon(
            Icons.add,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: StreamBuilder(
            stream: trips.orderBy('date').snapshots(),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: textPrimColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 1),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      // color: primaryColor,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  tripData['vehicle detail'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                const Spacer(),
                                Text(
                                  tripData['seat'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const Icon(
                                    color: Colors.white,
                                    Icons.airline_seat_recline_extra_rounded),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tripData['start point'],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                                Text(
                                  tripData['end point'],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 270,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          context, tripSnap.id);
                                    },
                                    child: const Text(
                                      'Delete Trip',
                                      style: TextStyle(
                                          color: textPrimColor, fontSize: 17),
                                    ),
                                  ),
                                ),
                              ],
                            )
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
