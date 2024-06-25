import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:info_cab_u/constant.dart';

class LoginPage extends StatefulWidget {
  static String verify = "";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // firebase auth instance
  FirebaseAuth auth = FirebaseAuth.instance;
  //text editing controller for phone number
  TextEditingController phoneController = TextEditingController();
  //setting country code
  var countryCode = '+91';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // the heading text to enter number
                  const HText(content: "Provide", textColor: black),
                  const HText(content: "Your Mobile Number", textColor: textPrimColor),
                  const SizedBox(height: 40),
                  TextFormField(
                    //text feild to enter phone number
                    controller: phoneController,
                    style: TextStyle(color: textSecColor),
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter Your Phone Number',
                      labelStyle: TextStyle(color: textSecColor),
                      prefixText: '+91 | ',
                      focusedBorder: OutlineInputBorder(
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
                    //validation to enter phone number
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Button(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {

                        //firebase part
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          //phone number to pass to firebase
                          phoneNumber: '${countryCode + phoneController.text}',
                          //function to call if verification is completed
                          verificationCompleted: (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {
                            // message to show if verification failed
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.message ?? 'Verification failed.')),
                            );
                          },
                          // for senting otp
                          codeSent: (String verificationId, int? resendToken) {
                            LoginPage.verify = verificationId;
                            // sending phone number as argument to next page
                            Navigator.pushNamed(context, '/otp', arguments: {
                              'phoneNumber': phoneController.text
                            });
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      }
                    },
                    text: 'Get OTP'
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'By clicking, I accept the ',
                              style: TextStyle(color: textSecColor, fontSize: 15),
                            ),
                            TextSpan(
                              text: 'terms of service ',
                              style: TextStyle(color: textSecColor, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'and',
                              style: TextStyle(color: textSecColor, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'privacy policy ',
                        style: TextStyle(fontSize: 15, color: textSecColor, fontWeight: FontWeight.bold),
                      )
                    ],
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
