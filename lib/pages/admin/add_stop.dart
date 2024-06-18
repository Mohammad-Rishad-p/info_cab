import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Pick Up Point',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddPickUpPointPage(),
    );
  }
}

class AddPickUpPointPage extends StatelessWidget {
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
            Button(onPressed: (){}, text: 'Add Points')
            // ElevatedButton(
            //   onPressed: () {
            //     // Add your onPressed code here!
            //   },
            //   child: Text('Add Points'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Color(0xFF364A86), // Button background color
            //     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            //     textStyle: TextStyle(fontSize: 16),
            //
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
