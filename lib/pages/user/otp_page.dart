import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:info_cab_u/constant.dart';
import 'package:info_cab_u/pages/user/login_page.dart';
import 'package:info_cab_u/pages/user/user_register_page.dart';
import 'package:pinput/pinput.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  // text editting controller for otp
  TextEditingController otpController = TextEditingController();
  // instance for firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // taking the arguments from loginpage to get phone number
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String phoneNumber = args['phoneNumber'];

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // the heading text for enter your otp
                const HText(content: "Enter", textColor: black),
                HText(content: "Your OTP for $phoneNumber", textColor: textPrimColor),
                const SizedBox(height: 40),
                // for setting the 6 box to enter otp 
                Pinput(
                  controller: otpController,
                  length: 6,
                  onChanged: (value) {
                    // Handle OTP input changes if needed
                  },
                ),
                const SizedBox(height: 30),
                Button(
                  onPressed: () async {
                    try {
                      //firebase part
                      // fuction to check the verification is completed
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: LoginPage.verify,
                        smsCode: otpController.text,
                      );

                      UserCredential userCredential = await auth.signInWithCredential(credential);
                      User? user = userCredential.user;

                      if (user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            //passing the uid to user register page
                            builder: (context) => UserRegisterPage(uid: user.uid),
                          ),
                        );
                      }
                    } catch (e) {
                      //message to display if otp verification is failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to verify OTP: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  // text to display in button
                  text: 'Verify OTP'
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
    );
  }
}
