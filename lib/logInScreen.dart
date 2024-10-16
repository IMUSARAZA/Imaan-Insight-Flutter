import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prayerapp/const/appColors.dart';
import 'package:prayerapp/const/customButton.dart';
import 'package:prayerapp/firebase_options.dart';
import 'package:prayerapp/onBoarding.dart';
import 'package:prayerapp/widgets/homeNavigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const logInScreen());
}

User? _user;
bool? userPassCorrect;
String? justLoggedInUser;

class logInScreen extends StatefulWidget {
  const logInScreen({super.key});

  @override
  State<logInScreen> createState() => _logInScreenState();
}

class _logInScreenState extends State<logInScreen> {
  bool _obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                        ),
                        Text(
                          'Log In',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 40,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          "Welcome back, let's get started",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 5, 40, 5),
                  child: TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.black),
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
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 5, 40, 5),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 168, 160, 160),
                      ),
                      hintText: "Enter your password",
                      labelStyle:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      floatingLabelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      labelText: "Password",
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off, color: appColors.appBasic,),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 20, 65, 0),
                  child: customButton(title: "Log In", onPressed: () {
                    logIn();
                  },),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5, right: 50),
                      child: TextButton(
                        onPressed: () {
                          // Handle button press
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.transparent, 
                        ),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black,
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
      ),
    );
  }

  void logIn() async {
    _user = await signInWithEmailPass(
        emailController.text, passwordController.text);

    if (_user != null) {
      print("Logged In Succesfully");
      justLoggedInUser = emailController.text;
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => homeNavigation("Lahore")),
        );
      });
    } else {
      print("User does not exist");
    }
  }
}
