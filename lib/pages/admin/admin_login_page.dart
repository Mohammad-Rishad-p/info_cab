import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      SnackBar(content: Text('Login Success'));
      print('Login successful: ${userCredential.user}');
      _saveAuthCredentialsAdmin(true);

      Navigator.pushNamed(context, '/adminDashboard');
    } catch (e) {
      SnackBar(content: Text('Login Failed'));
      print('Login failed: $e');
    }
  }

  void _saveAuthCredentialsAdmin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthAdmin', value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HText(content: 'Login As', textColor: Colors.black),
                  HText(content: 'Admin', textColor: textPrimColor),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Enter Email',
                      labelStyle: TextStyle(color: textSecColor),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: textSecColor,
                      ),
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
                        return 'Please Enter Email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: 80,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Enter Password',
                        labelStyle: TextStyle(color: textSecColor),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: textSecColor,
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: textSecColor, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: textSecColor, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: textSecColor, width: 2.0),
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
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Button(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signIn();
                        }
                      },
                      text: 'Login'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
