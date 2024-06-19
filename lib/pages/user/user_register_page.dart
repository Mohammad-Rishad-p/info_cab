import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:info_cab_u/basic_widgets/normal_text_widget.dart';
import 'package:info_cab_u/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRegisterPage extends StatefulWidget {
  @override
  _UserRegisterPageState createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  // text editing controllers to store user name and phone number
  TextEditingController userName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _selectedCompany = '';
  List<String> _companies = [''];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCompanies();
  }

  // to create instance for user collection
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  // instance for the collection companies
  final CollectionReference companies =
      FirebaseFirestore.instance.collection('companies');
  // function add users into firestore
  void addUsersToFirestore() {
    final data = {
      'name': userName.text,
      'phone number': phoneNumber.text,
      'company': _selectedCompany
    };
    try {
      users.add(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('successfully registerd user'),
          // backgroundColor: primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register user: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
    ;
  }

  Future<void> fetchCompanies() async {
    try {
      // to get data from stops collection
      QuerySnapshot querySnapshot = await companies.get();
      // converting datas in stops collection to a list
      List<String> fetchedCompanies = querySnapshot.docs
          .map((doc) => doc['company name'] as String)
          .toList();
      setState(() {
        _companies = fetchedCompanies;
        _selectedCompany = _companies.isNotEmpty ? _companies[0] : '';
      });
    } catch (e) {
      print("Failed to fetch stops: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading Text
                  const HText(content: 'Provide', textColor: blackText),
                  const HText(
                      content: 'Your Information', textColor: textPrimColor),
                  const SizedBox(
                    height: 45,
                  ),

                  //Text field for Phone Number
                  TextFormField(
                    controller: phoneNumber,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Enter Your Mobile Number',
                      labelStyle: TextStyle(color: textSecColor),
                      prefixText: '+91 ',
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
                        return 'Please enter your mobile number';
                      } else if (value.length != 10) {
                        return 'Mobile number must be exactly 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 13.0),
                  //text field for Name
                  TextFormField(
                    controller: userName,
                    decoration: const InputDecoration(
                      labelText: 'Enter Your Name',
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
                        return 'Please enter your name';
                      }
                      if (value.length < 3) {
                        return 'Name must be at least 3 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 35.0),
                  //Drop down box for company names
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Enter Your Company Name',
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
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCompany = newValue!;
                      });
                    },
                    items: _companies.map((company) {
                      return DropdownMenuItem(
                        value: company,
                        child: Text(
                          company,
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 25.0),

                  //Submit Button
                  SizedBox(
                      width: double.infinity,
                      child: Button(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
                            addUsersToFirestore();
                          },
                          text: 'Submit')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
