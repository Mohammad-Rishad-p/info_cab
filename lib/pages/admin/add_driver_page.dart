import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import '../../constant.dart';

class AddDriverPage extends StatefulWidget {
  const AddDriverPage({super.key});

  @override
  State<AddDriverPage> createState() => _AddDriverPageState();
}

class _AddDriverPageState extends State<AddDriverPage> {
  final CollectionReference drivers =
  FirebaseFirestore.instance.collection('drivers');

  final _formKey = GlobalKey<FormState>();

  TextEditingController driverNameController = TextEditingController();
  TextEditingController driverMobileNumberController = TextEditingController();

  Future<bool> _driverExists() async {
    final querySnapshot = await drivers
        .where('name', isEqualTo: driverNameController.text)
        .where('number', isEqualTo: driverMobileNumberController.text)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  void addDriver() async {
    if (await _driverExists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This driver already exists'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await drivers.add({
        'name': driverNameController.text,
        'number': driverMobileNumberController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Driver added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form fields
      driverNameController.clear();
      driverMobileNumberController.clear();
      setState(() {});
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add driver: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Drivers',
          
          ),
          centerTitle: true,
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios_new_rounded)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: driverNameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_2_outlined,
                        color: textSecColor,
                      ),
                      labelText: 'Name',
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
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: driverMobileNumberController,
                    maxLength: 10,
                    buildCounter: (context,
                        {required int currentLength,
                          required bool isFocused,
                          required int? maxLength}) {
                      return null; // This suppresses the max length indicator
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: textSecColor,
                      ),
                      labelText: 'Mobile Number',
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
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Mobile';
                      }
                      if (value.length != 10) {
                        return 'Mobile number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Button(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addDriver();
                      }
                    },
                    text: 'Add',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
