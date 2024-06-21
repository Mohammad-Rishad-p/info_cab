import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:info_cab_u/constant.dart';
import 'package:info_cab_u/pages/user/dashboard_page.dart';
import 'package:info_cab_u/pages/user/home_page.dart';
import 'package:info_cab_u/pages/user/login_page.dart';
import 'package:info_cab_u/pages/user/user_register_page.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  TextEditingController otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    void _saveAuthCredentialsInOtp(bool value) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuth', value);
    }
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 60,
      textStyle: TextStyle(
          fontSize: 20, color: textSecColor, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: textSecColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: textPrimColor, width: 2),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(color: Colors.white),
    );

    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String phoneNumber = args['phoneNumber'];

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HText(content: "Enter Your OTP for", textColor: black),
                HText(content: "$phoneNumber", textColor: textPrimColor),
                const SizedBox(height: 40),
                Pinput(
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  controller: otpController,
                  length: 6,
                ),
                const SizedBox(height: 30),
                Button(
                    onPressed: () async {
                      try {
                        PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                          verificationId: LoginPage.verify,
                          smsCode: otpController.text,
                        );

                        UserCredential userCredential =
                        await auth.signInWithCredential(credential);
                        User? user = userCredential.user;

                        if (user != null) {
                          DocumentSnapshot userDoc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .get();

                          if (userDoc.exists) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DashboardPage(),
                              ),
                            );
                            _saveAuthCredentialsInOtp(true);
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserRegisterPage(uid: user.uid),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User is null'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to verify OTP: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    text: 'Verify OTP'),
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
