import 'package:flutter/material.dart';
import '../../constant.dart';
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
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const RoundImage(
                src:
                    'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=600',
                radius: 90),
            const SizedBox(height: 32.0),
            ListTile(
              leading: Icon(Icons.local_taxi),
              title: Text('Trips'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 15.0),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Payments'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 15.0),
            ListTile(
              leading: Icon(Icons.taxi_alert_sharp),
              title: Text('Driver Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 15.0),
            ListTile(
              leading: Icon(Icons.warning_amber_outlined),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 15.0),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 25.0),
          ],
        ),
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
                    labelText: 'Starting From',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: textSecColor, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textSecColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.redAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.redAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
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
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: textSecColor, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textSecColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.redAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.redAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
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
                  suffixIcon: Icon(Icons.calendar_month_outlined),
                  labelText: 'Date',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: textSecColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: OutlineInputBorder(
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
                  text: _selectedDate.toString().substring(0, 10),
                ),
              ),
              const SizedBox(height: 32.0),
              Button(onPressed: () {}, text: "Submit"),
              const SizedBox(
                height: 15,
              ),
              Button(onPressed: () {}, text: 'Book Return'),
            ],
          ),
        ),
      ),
    );
  }
}
