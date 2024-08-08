import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:intl/intl.dart';

import '../../constant.dart';

class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({super.key});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final CollectionReference vehicles =
      FirebaseFirestore.instance.collection('vehicles');

  TextEditingController seatNumberController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // final TextEditingController _timeController = TextEditingController();

  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked != null) {
  //     final now = DateTime.now();
  //     final selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
  //     final formattedTime = DateFormat('hh:mm a').format(selectedTime);
  //     setState(() {
  //       _timeController.text = formattedTime;
  //     });
  //   }
  // }

  void addVehicle() async {
    try {
      await vehicles.add({
        'vehicle': vehicleController.text,
        'seat number': seatNumberController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehicle added successfully!'),
        ),
      );
      seatNumberController.clear();
      vehicleController.clear();

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add trip: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    seatNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle'),
        centerTitle: true,
      ),
      drawer: Drawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: vehicleController,
                  style: TextStyle(color: textSecColor),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      CupertinoIcons.car_detailed,
                      color: textSecColor,
                    ),
                    labelText: 'Enter Vehicle',
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
                      return 'Please Vehicle';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: seatNumberController,
                  style: const TextStyle(color: textSecColor),
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total Seats',
                    labelStyle: TextStyle(color: textSecColor),
                    prefixIcon: Icon(
                      CupertinoIcons.number,
                      color: textSecColor,
                    ),
                    focusedBorder: OutlineInputBorder(
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
                    ),
                  ),
                  //validation to enter phone number
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Total Seat Available';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Button(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addVehicle();
                    }
                  },
                  text: 'Add',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
