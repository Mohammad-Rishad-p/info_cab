
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';

class AddCompanyPage extends StatefulWidget {
  @override
  State<AddCompanyPage> createState() => _AddPickUpPointPageState();
}

class _AddPickUpPointPageState extends State<AddCompanyPage> {
  // Adding textediting controller
  TextEditingController addCompany = TextEditingController();

  // Firebase instance
  final CollectionReference companies =
      FirebaseFirestore.instance.collection('companies');

  // Function to add companies to Firestore
  void addStopsToFireStore() async {
    final data = {
      'company name': addCompany.text.trim()
    }; // Trimmed text to remove any leading/trailing whitespace
    if (addCompany.text.trim().isEmpty) {
      // Show a message if the text field is empty
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Company names cannot be empty')));
      return;
    }
    try {
      await companies.add(data);
      // to show a toast message if successful
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Company added successfully')));
      addCompany.clear();
      print("Company added successfully");
    } catch (e) {
      // to show a toast message if unsuccessful
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add company: $e')));
      print("Failed to add company: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Company'),
        centerTitle: true,
      ),
      drawer: Drawer(), // Adds a placeholder for the drawer icon
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: addCompany,
              decoration: InputDecoration(
                labelText: 'Enter Company Name',
                prefixIcon: Icon(Icons.apartment),
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
            Button(onPressed: () {
              addStopsToFireStore();
            }, text: 'Add Company'),
          ],
        ),
      ),
    );
  }
}
