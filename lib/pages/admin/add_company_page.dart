import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';

import '../../constant.dart';

class AddCompanyPage extends StatefulWidget {
  @override
  State<AddCompanyPage> createState() => _AddPickUpPointPageState();
}

class _AddPickUpPointPageState extends State<AddCompanyPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController companyController = TextEditingController();

  final CollectionReference companies =
      FirebaseFirestore.instance.collection('companies');

  void addCompany() async {
    try {
      final data = {
        'company name': companyController.text
      };
      await companies.add(data);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Company added successfully')));
      companyController.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add company: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Company'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: companyController,
                decoration: const InputDecoration(
                  labelText: 'Enter Company Name',
                  labelStyle: TextStyle(
                    color: textSecColor
                  ),
                  prefixIcon: Icon(
                    Icons.apartment,
                    color: textSecColor,
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
                style: TextStyle(
                  color: textSecColor,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Company Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Button(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addCompany();
                    }
                  },
                  text: 'Add Company'),
            ],
          ),
        ),
      ),
    );
  }
}
