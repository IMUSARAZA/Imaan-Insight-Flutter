import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:prayerapp/SignUpData.dart';
import 'package:prayerapp/const/customButton.dart';
import 'const/appColors.dart';
import 'signUpScreen.dart';

class OTP extends StatefulWidget {
  final int otpCode;
  final String userEmail;

  const OTP(this.otpCode, this.userEmail, {super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  int? otpEntered;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Image.asset(
                  "lib/Assets/salat.png",
                  height: screenHeight / 2 - 100,
                  width: screenWidth / 2,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
                    child: Text(
                      "OTP Code",
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 40,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 40),
                    child: Text(
                      "We have sent the OTP Code on to your given Email address",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Center(
                    child: OTPTextField(
                      outlineBorderRadius: 5,
                      keyboardType: TextInputType.number,
                      otpFieldStyle: OtpFieldStyle(
                        enabledBorderColor: appColors.appBasic,
                        focusBorderColor: appColors.appBasic,
                        backgroundColor: const Color(0xffffffff),
                      ),
                      length: 4,
                      width: MediaQuery.of(context).size.width - 50,
                      fieldWidth: 50,
                      style: const TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.underline,
                      onChanged: (value) => otpEntered = int.parse(value),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          "Didn't receive the code yet? ",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            getOTP();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ),
                          child: const Text(
                            "Resend",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: appColors.appBasic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(70, 20, 65, 0),
                    child: Material(
                      child: InkWell(
                        child: customButton(
                          title: 'Enter',
                          onPressed: () {
                            print(widget.otpCode);
                            print(otpEntered);
                            if (otpEntered == widget.otpCode) {
                              print("OTP Verified Successfully");
                              const Text('OTP Verified Successfully!');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SignUpData(widget.userEmail)),
                              );
                            } else {
                              const Text('Invalid OTP');
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
