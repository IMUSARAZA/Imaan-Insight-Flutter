import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prayerapp/OTP.dart';
import 'package:prayerapp/const/customButton.dart';
import 'package:prayerapp/firebase_options.dart';
import 'const/appColors.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const First());
}

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: signUpScreen(),
    );
  }
}

  bool _obscureText = true;
  String email = '';
  String password = '';
  TextEditingController emailController = TextEditingController();
  int otpCode = 0;
  
class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  

  @override
  Widget build(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

      return Scaffold(
        body: SizedBox(
          height: screenHeight,
          width: screenWidth,
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
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                        ),
                        Text(
                          'Sign Up',
                          style: GoogleFonts.roboto(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: const Color(0xff000000)),
                        ),
                        Text("To get started, enter your Email",
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: const Color(0xff000000))),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 40, 20),
                  child: TextFormField(
                    controller: emailController,
                    style: GoogleFonts.roboto(color: Colors.black),
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 168, 160, 160),
                      ),
                      hintText: "Enter your email",
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      labelText: "Email",
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            BorderSide(color: appColors.appBasic, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            BorderSide(color: appColors.appBasic, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            BorderSide(color: appColors.appBasic, width: 1.0),
                      ),
                    ),
                    onChanged: (value) => email = value,
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 20, 65, 0),
                  child: customButton(
                    title: 'Sign Up', 
                    onPressed: () {
                      if (email.isNotEmpty) {
                        getOTP();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTP(otpCode, emailController.text),
                          ),
                        );
                      } else {
                        print('Email is empty');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
  void getOTP() async {
    otpCode = generateOTP();
    try {
      final mailer = Mailer(
          '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');
      final toAddress = Address(extractEmail());
      final fromAddress = Address('insightimaan@gmail.com');
      final content = Content('text/plain',
          'Hello! Welcome to Imaan Insight!\nYour One-Time-Password (OTP) code is $otpCode');
      final subject = 'OTP Verification for Imaan Insight';
      final personalization = Personalization([toAddress]);

      final email =
          Email([personalization], fromAddress, subject, content: [content]);
      final result = await mailer.send(email);
      print('RESULT: $result');
    } catch (e) {
      print('Error sending email: $e');
    }
          print('OTP CODE IS: $otpCode');

  }

  String extractEmail() {
    String inputText = emailController.text;
    RegExp emailRegExp =
        RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    Iterable<Match> matches = emailRegExp.allMatches(inputText);

    if (matches.isNotEmpty) {
      String emailAddress = matches.first.group(0)!;
      return emailAddress;
    } else {
      return 'No email address found.';
    }
  }

  int generateOTP() {
  Random random = Random();
  int otp = random.nextInt(9000) + 1000; 

  return otp;
}
