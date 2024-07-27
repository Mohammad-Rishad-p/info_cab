import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/constant.dart';
import '../../model/users.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;

  EditProfilePage({required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String _selectedCompany = '';
  List<String> _companies = [];

  final _formKey = GlobalKey<FormState>();

  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final CollectionReference companies = FirebaseFirestore.instance.collection('companies');

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    fetchCompanies();
  }

  Future<void> fetchUserDetails() async {
    try {
      DocumentSnapshot userSnapshot = await users.doc(widget.userId).get();
      if (userSnapshot.exists) {
        setState(() {
          userNameController.text = userSnapshot['name'] ?? '';
          phoneNumberController.text = userSnapshot['phone number'] ?? '';
          _selectedCompany = userSnapshot['company'] ?? '';
        });
      }
    } catch (e) {
      print("Failed to fetch user details: $e");
    }
  }

  Future<void> fetchCompanies() async {
    try {
      QuerySnapshot querySnapshot = await companies.get();
      List<String> fetchedCompanies = querySnapshot.docs.map((doc) => doc['company name'] as String).toList();
      setState(() {
        _companies = fetchedCompanies;
        if (_companies.isNotEmpty && !_companies.contains(_selectedCompany)) {
          _selectedCompany = _companies[0];
        }
      });
    } catch (e) {
      print("Failed to fetch companies: $e");
    }
  }

  void updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'name': userNameController.text,
        'phone number': phoneNumberController.text,
        'company': _selectedCompany,
      };

      try {
        await users.doc(widget.userId).update(updatedData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: userNameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Name',
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
                      borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: phoneNumberController,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Enter Your Number',
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
                          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedCompany,
                    items: _companies.map((String company) {
                      return DropdownMenuItem<String>(
                        value: company,
                        child: Text(company),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCompany = newValue!;
                      });
                    },
                      decoration: const InputDecoration(
                        labelText: 'Company',
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
                          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    style: const TextStyle(fontSize: 16,color: textSecColor),
                  ),
                  const SizedBox(height: 30),
                  Button(
                    onPressed: updateUserProfile,
                    text: 'Save Changes',
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
