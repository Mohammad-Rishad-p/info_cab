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
  final CollectionReference stops =
  FirebaseFirestore.instance.collection('stops');
  final _formKey = GlobalKey<FormState>();
  late User? currentUser;
  String _selectedStartPoint = 'Alappuzha';
  String _selectedEndPoint = 'Alappuzha';
  DateTime _selectedDate = DateTime.now();
  List<String> _stops = [];

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    fetchStops();
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

  void bookCab(String tripId) async {
    String? userId = currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    QuerySnapshot existingBookings = await FirebaseFirestore.instance
        .collection('bookings')
        .where('tripId', isEqualTo: tripId)
        .where('userId', isEqualTo: userId)
        .get();

    if (existingBookings.docs.isEmpty) {
      FirebaseFirestore.instance.collection('bookings').add({
        'tripId': tripId,
        'userId': userId,
        'date': DateTime.now().toIso8601String(),
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cab booked successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book cab: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have already booked this trip')),
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
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: DrawerUser(),
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
                style: TextStyle(color: textSecColor),
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
                    });
                  }
                },
                controller: TextEditingController(
                  text: DateFormat('yyyy-MM-dd').format(_selectedDate),
                ),
              ),
              const SizedBox(height: 25.0),
              Button(
                onPressed: () {
                  // Call the function to book the cab
                  bookCab(args!['tripId']);
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
