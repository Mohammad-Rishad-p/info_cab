import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:intl/intl.dart';

import '../../constant.dart';

class AddTripsPage extends StatefulWidget {
  const AddTripsPage({super.key});

  @override
  State<AddTripsPage> createState() => _AddTripsPageState();
}

class _AddTripsPageState extends State<AddTripsPage> {
  TextEditingController seatNumberController = TextEditingController();
  TextEditingController startPointController = TextEditingController();
  TextEditingController endPointController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _selectedStartPoint = '';
  String _selectedEndPoint = '';
  String _selectedVehicle = '';
  String _selectedSeat = '';

  DateTime _selectedDate = DateTime.now();
  List<String> _stops = [];
  List<String> _vehicles = [];

  final CollectionReference stops =
      FirebaseFirestore.instance.collection('stops');
  final CollectionReference trips =
      FirebaseFirestore.instance.collection('trips');
  final CollectionReference vehicles =
      FirebaseFirestore.instance.collection('vehicles');

  @override
  void initState() {
    super.initState();
    _fetchStops();
    _fetchVehicles();
  }

  Future<void> _fetchStops() async {
    final querySnapshot = await stops.get();
    final stopNames =
        querySnapshot.docs.map((doc) => doc['stop'].toString()).toList();
    setState(() {
      _stops = stopNames;
      _selectedStartPoint = _stops.isNotEmpty ? _stops[0] : '';
    });
  }

  Future<void> _fetchVehicles() async {
    final querySnapshot = await vehicles.get();
    final vehicleNames =
        querySnapshot.docs.map((doc) => doc['vehicle'].toString()).toList();
    setState(() {
      _vehicles = vehicleNames;
      _selectedVehicle = _vehicles.isNotEmpty ? _vehicles[0] : '';
    });
  }

//to avoid duplication of data while adding to db

  Future<bool> _tripExists() async {
    final querySnapshot = await trips
        .where('start point', isEqualTo: _selectedStartPoint)
        .where('date',
            isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDate))
        .where('vehicle detail', isEqualTo: _selectedVehicle)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  void addTrips() async {
    if (await _tripExists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Trip with same starting point, date, and vehicle already exists!'),
          // backgroundColor: Colors.red,
        ),
      );
      return; // return so already exist ayathond fn (addTrips) nn complete exit adikkum soo add avulla
    }

    try {
      await trips.add({
        'start point': _selectedStartPoint,
        'end point': _selectedEndPoint,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'vehicle detail': _selectedVehicle,
        'seat': seatNumberController.text
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip added successfully!'),
          // backgroundColor: Colors.green,
        ),
      );

      // Clear form fields
      seatNumberController.clear();
      setState(() {
        _selectedStartPoint = _stops.isNotEmpty ? _stops[0] : '';
        _selectedEndPoint = _stops.isNotEmpty ? _stops[0] : '';
        _selectedVehicle = _vehicles.isNotEmpty ? _vehicles[0] : '';
        _selectedDate = DateTime.now();
        dateController.text = '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add trip: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Trips',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30.0),
                // starting from dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: 'Starting From',
                      labelStyle: TextStyle(color: textSecColor),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: textSecColor, width: 2.0),
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
                      _selectedStartPoint = newValue!;
                    });
                  },
                  items: _stops.map((company) {
                    return DropdownMenuItem(
                      value: company,
                      child: Text(company),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Select Starting point';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),

                //end point drop down
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: 'EndPoint',
                      labelStyle: TextStyle(color: textSecColor),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: textSecColor, width: 2.0),
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
                      _selectedEndPoint = newValue!;
                    });
                  },
                  items: _stops.map((company) {
                    return DropdownMenuItem(
                      value: company,
                      child: Text(
                        company,
                        style: TextStyle(color: textSecColor),
                      ),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Select Endpoint';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  style: TextStyle(color: textSecColor),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.calendar_month_outlined,
                      color: textSecColor,
                    ),
                    labelText: 'Date',
                    labelStyle: TextStyle(color: textSecColor),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Select Date';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: 'Vehicle',
                      labelStyle: TextStyle(color: textSecColor),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: textSecColor, width: 2.0),
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
                      _selectedVehicle = newValue!;
                    });
                  },
                  value: _selectedVehicle,
                  items: _vehicles.map((vehicle) {
                    return DropdownMenuItem(
                      value: vehicle,
                      child: Text(
                        vehicle,
                        style: const TextStyle(color: textSecColor),
                      ),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Select Vehicle';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: seatNumberController,
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Number of seats',
                    labelStyle: TextStyle(color: textSecColor),
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
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Seat Number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Button(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addTrips();
                      }
                    },
                    text: 'Submit')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
