import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Booking {
  String id;
  String tripId;
  String userId;
  String startPoint;
  String endPoint;
  DateTime tripDate;
  DateTime bookedDate;

  Booking({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.startPoint,
    required this.endPoint,
    required this.tripDate,
    required this.bookedDate,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return Booking(
      id: doc.id,
      tripId: data['tripId'] ?? '',
      userId: data['userId'] ?? '',
      startPoint: data['startPoint'] ?? '',
      endPoint: data['endPoint'] ?? '',
      tripDate: DateTime.parse(data['tripDate']),
      bookedDate: DateTime.parse(data['bookedDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'userId': userId,
      'startPoint': startPoint,
      'endPoint': endPoint,
      'tripDate': DateFormat('yyyy-MM-dd').format(tripDate),
      'bookedDate': DateFormat('yyyy-MM-dd').format(bookedDate),
    };
  }
}
