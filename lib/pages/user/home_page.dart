import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';
import 'package:intl/intl.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/components/drawer_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final CollectionReference stops = FirebaseFirestore.instance.collection('stops');
  final _formKey = GlobalKey<FormState>();
  late User? currentUser;
  String _selectedStartPoint = 'Alappuzha';
  String _selectedEndPoint = 'Alappuzha';
  DateTime _selectedDate = DateTime.now();
  List<String> _stops = [];
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    fetchStops();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  Future<void> fetchStops() async {
    try {
      QuerySnapshot querySnapshot = await stops.get();
      List<String> fetchedStops =
      querySnapshot.docs.map((doc) => doc['stop'] as String).toList();
      setState(() {
        _stops = fetchedStops;
        _selectedStartPoint = _stops.isNotEmpty ? _stops[0] : '';
      });
    } catch (e) {
      print("Failed to fetch stops: $e");
    }
  }

  Future<void> bookingConfirmAlert(BuildContext context, String tripId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking?'),
          content: Text('Are you sure you want to Confirm this booking?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // dismiss the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: textPrimColor),
              ),
            ),
            TextButton(
              onPressed: () {
                bookCab(tripId);
                Navigator.of(context).pop(); // dismiss the dialog
              },
              child: Text('Confirm', style: TextStyle(color: textPrimColor)),
            ),
          ],
        );
      },
    );
  }

  void bookCab(String tripId) async {
    String? userId = currentUser?.uid;
    print("User ID: $userId");
    print("Trip ID: $tripId");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    DateTime bookingDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      7, // 7 AM
    );

    if (DateTime.now().isAfter(bookingDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking time is closed for this trip')),
      );
      return;
    }

    try {
      DocumentSnapshot tripDoc =
      await FirebaseFirestore.instance.collection('trips').doc(tripId).get();
      int seatCapacity = (tripDoc['seat'] is int) ? tripDoc['seat'] : int.parse(tripDoc['seat']);
      print("Seat Capacity: $seatCapacity");

      QuerySnapshot existingBookings = await FirebaseFirestore.instance
          .collection('bookings')
          .where('tripId', isEqualTo: tripId)
          .get();

      int numberOfBookings = existingBookings.docs.length;
      print("Number of Bookings: $numberOfBookings");

      if (numberOfBookings >= seatCapacity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The cab is fully booked')),
        );
        return;
      }
      // checking user already booked current service
      QuerySnapshot userBookings = await FirebaseFirestore.instance
          .collection('bookings')
          .where('tripId', isEqualTo: tripId)
          .where('userId', isEqualTo: userId)
          .get();

      if (userBookings.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('bookings').add({
          'tripId': tripId,
          'userId': userId,
          'startPoint': _selectedStartPoint,
          'endPoint': _selectedEndPoint,
          'tripDate': DateFormat('yyyy-MM-dd').format(_selectedDate),
          'bookedDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),

        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cab booked successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have already booked this trip')),
        );
      }
    } catch (e) {
      print("Error booking cab: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book cab: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    if (args != null) {
      _selectedStartPoint = args['start point'] as String;
      _selectedEndPoint = args['end point'] as String;
      _selectedDate = DateTime.parse(args['date'] as String);
      var seat = args['seat'] as String;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Cab'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 55.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'StartPoint',
                  labelStyle: TextStyle(color: textSecColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: textSecColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textSecColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textSecColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                value: _selectedStartPoint,
                onChanged: (newValue) {
                  setState(() {
                    _selectedStartPoint = newValue!;
                  });
                },
                items: _stops.map((stop) {
                  return DropdownMenuItem(
                    value: stop,
                    child: Text(stop),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'EndPoint',
                  labelStyle: TextStyle(color: textSecColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: textSecColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textSecColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textSecColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                value: _selectedEndPoint,
                onChanged: (newValue) {
                  setState(() {
                    _selectedEndPoint = newValue!;
                  });
                },
                items: _stops.map((stop) {
                  return DropdownMenuItem(
                    value: stop,
                    child: Text(stop),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25.0),
              TextFormField(
                style: const TextStyle(color: textSecColor),
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_month_outlined, color: textSecColor),
                  labelText: 'Date',
                  labelStyle: TextStyle(color: textSecColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: textSecColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textSecColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textSecColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                      _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
                    });
                  }
                },
                controller: _dateController,
              ),
              const SizedBox(height: 25.0),
              Button(
                onPressed: () {
                  // Call the function to book the cab
                  if (_formKey.currentState!.validate()) {
                    bookingConfirmAlert(context, args!['tripId']);
                  }
                },
                text: "Book Cab",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
