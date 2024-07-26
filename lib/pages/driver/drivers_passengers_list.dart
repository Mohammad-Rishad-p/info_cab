import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PassengersListPage extends StatelessWidget {
  const PassengersListPage({super.key});

  Future<Map<String, dynamic>> fetchTripAndUserDetails(String tripId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch booking details for the trip
    final bookingSnapshot = await firestore.collection('bookings')
        .where('tripId', isEqualTo: tripId)
        .get();

    if (bookingSnapshot.docs.isEmpty) {
      throw Exception('No bookings available for this trip');
    }

    final bookingData = bookingSnapshot.docs.first.data() as Map<String, dynamic>;
    final String userId = bookingData['userId'];

    // Fetch user details
    final userSnapshot = await firestore.collection('users').doc(userId).get();
    if (!userSnapshot.exists) {
      throw Exception('User not found');
    }

    final userData = userSnapshot.data() as Map<String, dynamic>;

    return {
      'personName': userData['name'],
      'pickupPoint': bookingData['pickupPoint'],
      'destinationPoint': bookingData['destinationPoint'],
    };
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

    );
  }
}
