import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckTrips extends StatefulWidget {
  const CheckTrips({Key? key}) : super(key: key);

  @override
  State<CheckTrips> createState() => _CheckTripsState();
}

class _CheckTripsState extends State<CheckTrips> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Trip'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'add_trip');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        tooltip: 'Create Trips',
        backgroundColor: textPrimColor,
      ),
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
                      color: Colors.white,
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                tripData['vehicle detail'],
                                style: const TextStyle(
                                    fontWeight:FontWeight.w600, fontSize: 18),
                              ),
                              const Spacer(),
                              Text(
                                tripData['seat'],
                                style: const TextStyle(fontSize: 18),
                              ),
                              const Icon(Icons.airline_seat_recline_extra_rounded),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tripData['start point'],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(Icons.arrow_forward),
                              Text(tripData['end point'],style: TextStyle(fontSize: 16),),
                              Text(
                                formattedDate,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      context, tripSnap.id);
                                },
                                child: Text(
                                  'Delete Trip',
                                  style: TextStyle(color: textPrimColor,fontSize: 17),
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
    );
  }
}
