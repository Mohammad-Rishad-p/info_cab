import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';

class PassengersListPage extends StatelessWidget {
  const PassengersListPage({super.key});

  Future<List<Map<String, dynamic>>> fetchTripAndUserDetails(String tripId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final bookingSnapshot = await firestore.collection('bookings')
        .where('tripId', isEqualTo: tripId)
        .get();

    if (bookingSnapshot.docs.isEmpty) {
      throw Exception('No bookings available for this trip');
    }

    List<Map<String, dynamic>> passengerDetails = [];

    for (var bookingDoc in bookingSnapshot.docs) {
      final bookingData = bookingDoc.data() as Map<String, dynamic>;
      final String userId = bookingData['userId'];

      final userSnapshot = await firestore.collection('users').doc(userId).get();
      if (!userSnapshot.exists) {
        throw Exception('User not found');
      }

      final userData = userSnapshot.data() as Map<String, dynamic>;

      passengerDetails.add({
        'personName': userData['name'],
        'pickupPoint': bookingData['startPoint'],
        'destinationPoint': bookingData['endPoint'],
      });
    }

    return passengerDetails;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String tripId = args['tripId'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Details'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTripAndUserDetails(tripId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No passengers found'));
          }

          final List<Map<String, dynamic>> passengerDetails = snapshot.data!;

          return ListView.builder(
            itemCount: passengerDetails.length,
            itemBuilder: (context, index) {
              final passenger = passengerDetails[index];
              return Card(
                color: textPrimColor,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        passenger['personName'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(
                            'Pickup: ${passenger['pickupPoint']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.flag, color: Colors.red),
                          const SizedBox(width: 10),
                          Text(
                            'Destination: ${passenger['destinationPoint']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
