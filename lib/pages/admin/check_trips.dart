import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';
import 'package:intl/intl.dart';

class CheckTrips extends StatefulWidget {
  const CheckTrips({super.key});

  @override
  State<CheckTrips> createState() => _CheckTripsState();
}

class _CheckTripsState extends State<CheckTrips> {
  final CollectionReference trips =
      FirebaseFirestore.instance.collection('trips');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Trip'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: trips.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No trips available'));
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return TripCard(
                id: doc.id,
                vehicle: data['vehicle detail'],
                seats: data['seat'],
                startPoint: data['start point'],
                endPoint: data['end point'],
                date: DateTime.parse(data['date']),
                onDelete: () async {
                  await trips.doc(doc.id).delete();
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  final String id;
  final String vehicle;
  final String seats;
  final String startPoint;
  final String endPoint;
  final DateTime date;
  final VoidCallback onDelete;

  TripCard({
    required this.id,
    required this.vehicle,
    required this.seats,
    required this.startPoint,
    required this.endPoint,
    required this.date,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primaryColor,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  vehicle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Spacer(),
                Text(
                  '$seats',
                  style: TextStyle(fontSize: 18),
                ),
                Icon(Icons.event_seat),
              ],
            ),
            SizedBox(height: 18.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  startPoint,
                  style: TextStyle(fontSize: 16),
                ),
                Icon(Icons.arrow_forward),
                Text(endPoint),
                Text(
                  DateFormat('yyyy-MM-dd').format(date),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: onDelete,
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
