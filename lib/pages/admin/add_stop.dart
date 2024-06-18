import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';

class AddPickUpPointPage extends StatefulWidget {
  @override
  State<AddPickUpPointPage> createState() => _AddPickUpPointPageState();
}

class _AddPickUpPointPageState extends State<AddPickUpPointPage> {
  // Adding textediting controller
  TextEditingController addStop = TextEditingController();

  // Firebase instance
  final CollectionReference stops = FirebaseFirestore.instance.collection('stops');

  // Function to add stop to Firestore
  void addStopsToFireStore() async {
    final data = {'stop': addStop.text};
    try {
      await stops.add(data);
      // to show a toast message  if successfull
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Stop added successfully')));
      addStop.clear();
      print("Stop added successfully");
    } catch (e) {
      // to show a toast message  if unsuccessfull
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add stop: $e')));
      print("Failed to add stop: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pick Up Point'),
        centerTitle: true,
      ),
      drawer: Drawer(), // Adds a placeholder for the drawer icon
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: addStop,
              decoration: InputDecoration(
                labelText: 'Enter Pick up points',
                prefixIcon: Icon(Icons.directions_bus),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Button(onPressed: addStopsToFireStore, text: 'Add Points'),
          ],
        ),
      ),
    );
  }
}