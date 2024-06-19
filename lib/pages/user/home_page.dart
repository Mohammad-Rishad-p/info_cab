import 'package:cloud_firestore/cloud_firestore.dart';
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

  // firbase instance to get stops collection
  final CollectionReference stops = FirebaseFirestore.instance.collection('stops');

  final _formKey = GlobalKey<FormState>();
  String _selectedCompany = 'Alappuzha';
  DateTime _selectedDate = DateTime.now();
  List<String> _stops = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStops();
  }

  // Fetch stops from Firestore and update the _stops list
  Future<void> fetchStops() async {
    try {
      // to get data from stops collection
      QuerySnapshot querySnapshot = await stops.get();
      // converting datas in stops collection to a list
      List<String> fetchedStops = querySnapshot.docs.map((doc) => doc['stop'] as String).toList();
      setState(() {
        // setting the fetched list to _stop list
        _stops = fetchedStops;
        _selectedCompany = _stops.isNotEmpty ? _stops[0] : '';
      });
    } catch (e) {
      print("Failed to fetch stops: $e");
    }
  }
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

      // menu
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //image in menu
            const RoundImage(
                src:
                    'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=600',
                radius: 90),
            const SizedBox(height: 32.0),
            // trips in menu
            ListTile(
              leading: Icon(Icons.local_taxi),
              title: Text('Trips'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            //payments in menu
            const SizedBox(height: 15.0),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Payments'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 15.0),
            // driver profile in menu
            ListTile(
              leading: Icon(Icons.taxi_alert_sharp),
              title: Text('Driver Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // about in in menu
            const SizedBox(height: 15.0),
            ListTile(
              leading: Icon(Icons.warning_amber_outlined),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            //logout
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


      //body
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 55.0),
              // starting from dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: 'Starting From',
                    labelStyle: TextStyle(
                        color: textSecColor
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: textSecColor, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textSecColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
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

              //end point drop down
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: 'EndPoint',
                    labelStyle: TextStyle(
                        color: textSecColor
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: textSecColor, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textSecColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
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
                  labelStyle: TextStyle(
                      color: textSecColor
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: textSecColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  text: _selectedDate.toString().substring(0, 10),
                ),
              ),
              const SizedBox(height: 32.0),
              Button(onPressed: () {}, text: "Book Cab"),
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
