import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';

class AddCompanyPage extends StatefulWidget {
  @override
  State<AddCompanyPage> createState() => _AddPickUpPointPageState();
}

class _AddPickUpPointPageState extends State<AddCompanyPage> {
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
            Button(onPressed: () {}, text: 'Add Company'),
          ],
        ),
      ),
    );
  }
}
