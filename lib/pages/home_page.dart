import 'package:flutter/material.dart';
import '../constant.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:info_cab_u/basic_widgets/normal_text_widget.dart';
import 'package:info_cab_u/components/container_card_widget.dart';
import 'package:info_cab_u/components/round_image_widget.dart';
import 'package:info_cab_u/components/bottom_navigation.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCompany = 'Alappuzha';
  DateTime _selectedDate = DateTime.now();
  final List<String> _stops = [
    'Alappuzha',
    'Ottapunna',
    'Thuravoor',
    'infopark',
    'Vayalar',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home',style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.local_activity),
              title: Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 3'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 55.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Starting From',
                  border: OutlineInputBorder(),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCompany = newValue!;
                  });
                },
                items: _stops.map((company) {
                  return DropdownMenuItem(
                    value: company,
                    child: Text(company),
                  );
                }).toList(),
              ),

              const SizedBox(height: 25.0),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'EndPoint',
                  border: OutlineInputBorder(),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCompany = newValue!;
                  });
                },
                items: _stops.map((company) {
                  return DropdownMenuItem(
                    value: company,
                    child: Text(company),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                controller: TextEditingController(
                  text: _selectedDate.toString().substring(0, 10),
                ),
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process data
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(buttonColor),
                      foregroundColor: MaterialStateProperty.all(primaryColor)
                  ),
                  child: const Text('Submit'),
                ),
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process data
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(buttonColor),
                      foregroundColor: MaterialStateProperty.all(primaryColor)
                  ),
                  child: const Text('Book Return'),
                ),
              ),
            ],
          ),
        ),
      ),



    );
  }
}