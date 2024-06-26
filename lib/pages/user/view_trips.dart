import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';
import 'package:intl/intl.dart';

class ViewTripsPage extends StatefulWidget {
  @override
  _ViewTripsPageState createState() => _ViewTripsPageState();
}

class _ViewTripsPageState extends State<ViewTripsPage> {
  final CollectionReference trips =
      FirebaseFirestore.instance.collection('trips');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Trip'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: trips.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No trips available'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot tripSnap = snapshot.data!.docs[index];
                return Card(
                  color: primaryColor,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/home',
                        arguments: {
                          'tripId': tripSnap.id,
                          'date': tripSnap['date'],
                          'start point': tripSnap['start point'],
                          'end point': tripSnap['end point'],
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
                                tripSnap['vehicle detail'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Spacer(),
                              Text(
                                tripSnap['seat'],
                                style: TextStyle(fontSize: 18),
                              ),
                              Icon(Icons.event_seat),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tripSnap['start point'],
                                style: TextStyle(fontSize: 16),
                              ),
                              Icon(Icons.arrow_forward),
                              Text(tripSnap['end point']),
                              Text(
                                tripSnap['date'].toString(),
                                style: TextStyle(fontSize: 16),
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
    );
  }
}
