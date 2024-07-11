import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:info_cab_u/basic_widgets/normal_text_widget.dart';
import 'package:info_cab_u/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/users.dart';

class UserRegisterPage extends StatefulWidget {
  final String uid;

  UserRegisterPage({required this.uid});

  @override
  _UserRegisterPageState createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  TextEditingController userName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _selectedCompany = '';
  List<String> _companies = [''];

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final CollectionReference companies = FirebaseFirestore.instance.collection('companies');

  void addUsersToFirestore() async {
    // final data = {
    //   'name': userName.text,
    //   'phone number': phoneNumber.text,
    //   'company': _selectedCompany
    // };

    final user = Users(
      name: userName.text,
      number: phoneNumber.text,
      company: _selectedCompany,
    );


    try {
      // await users.doc(widget.uid).set(data);

      await users.doc(widget.uid).set(user.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully registered user'),
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register user: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchCompanies() async {
    try {
      QuerySnapshot querySnapshot = await companies.get();
      List<String> fetchedCompanies = querySnapshot.docs.map((doc) => doc['company name'] as String).toList();  //
      setState(() {
        _companies = fetchedCompanies;
        _selectedCompany = _companies.isNotEmpty ? _companies[0] : '';
      });
    } catch (e) {
      print("Failed to fetch companies: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    void _saveAuthCredentials(bool value) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuth', value);
    }
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HText(content: 'Provide', textColor: blackText),
                  const HText(content: 'Your Information', textColor: textPrimColor),
                  const SizedBox(height: 45),

                  TextFormField(
                    controller: phoneNumber,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: textSecColor),
                    decoration: const InputDecoration(
                      counterText: '',
                      labelText: 'Enter Your Mobile Number',
                      labelStyle: TextStyle(color: textSecColor),
                      prefixText: '+91 | ',
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
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: userName,
                    style: const TextStyle(color: textSecColor),
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
                  const SizedBox(height: 30),

                  DropdownButtonFormField<String>(
                    value: _selectedCompany,
                    items: _companies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {  // onchanged store to newvalue
                      setState(() {
                        _selectedCompany = newValue!;
                      });
                    },
                    style: const TextStyle(color: textSecColor,fontSize: 17),
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
                  ),
                  const SizedBox(height: 30),
                  Button(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addUsersToFirestore();
                        _saveAuthCredentials(true);
                      }
                    },
                    text: 'Register',
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
