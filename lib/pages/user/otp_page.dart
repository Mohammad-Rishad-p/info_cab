import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/button_widget.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:info_cab_u/basic_widgets/normal_text_widget.dart';
import 'package:info_cab_u/constant.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final int number = 8891160597;

  List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    // Dispose of controllers and focus nodes
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.white
      ),
    );
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // heading part with phone number
            HText(content: 'Verify with OTP sent to', textColor: black),
            HText(content: number.toString(), textColor: textPrimColor),
            SizedBox(
              height: 30,
            ),
            Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              // showCursor: true,
              // onCompleted: (pin) => print(pin),
            ),
            // Row(
            //   // the six boxes to enter otp
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: List.generate(6, (index) {
            //     return Container(
            //       width: 50,
            //       height: 60,
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.grey, width: 2.0),
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       // design of a single box
            //       child: TextField(
            //         style: TextStyle(
            //             color: textSecColor,
            //             fontSize: 24
            //         ),
            //         controller: controllers[index],
            //         focusNode: focusNodes[index],
            //         maxLength: 1,
            //         textAlign: TextAlign.center,
            //         keyboardType: TextInputType.number,
            //         decoration: InputDecoration(
            //           border: InputBorder.none,
            //           counterText: '',
            //         ),
            //         onChanged: (value) {
            //           if (value.isNotEmpty && index < 5) {
            //             FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            //           } else if (value.isEmpty && index > 0) {
            //             FocusScope.of(context).requestFocus(focusNodes[index - 1]);
            //           }
            //         },
            //         onSubmitted: (value) {
            //           if (value.isEmpty && index > 0) {
            //             FocusScope.of(context).requestFocus(focusNodes[index - 1]);
            //           }
            //         },
            //       ),
            //     );
            //   }),
            // ),
            const SizedBox(
              height: 20,
            ),

            const Row(
              children: [
                SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    color: textPrimColor,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),

                NText(content: 'Auto fetching OTP..', textColor: textSecColor)
              ],
            ),
            const SizedBox(
              height: 24,
            ),

            // otp submit button
            Button(onPressed: () {

            }, text: 'Verify OTP'),
          ],
        ),
      ),
    ));
  }
}
