import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prayerapp/SignUpData.dart';
import 'package:prayerapp/logInScreen.dart';
import 'package:prayerapp/signUpScreen.dart';
import 'package:prayerapp/widgets/homeNavigation.dart';


    User? loggedInUser;
    final FirebaseAuth _auth = FirebaseAuth.instance;

User? _user;
class fristRun extends StatefulWidget {
  const fristRun({super.key});

  @override
  State<fristRun> createState() => _fristRunState();
}

class _fristRunState extends State<fristRun> {


  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _user != null ? const homeNavigation('Lahore') : const onBoarding(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, 
      ),
    );
  }
}



class onBoarding extends StatefulWidget {
  const onBoarding({super.key});

  @override
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
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
                  height: screenHeight / 2,
                  width: screenWidth / 2,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                      child: MaterialButton(
                        onPressed: () async {
                          await handleGooleSignIn();

                          if (_auth.currentUser != null) {
                            setState(() {
                              
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SignUpData(_auth.currentUser!.email!)),
                            );
                          }
                        },
                        color: const Color.fromARGB(255, 255, 255, 255),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255),
                              width: 1),
                        ),
                        textColor: const Color.fromARGB(255, 0, 0, 0),
                        height: 60,
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Image(
                              image: AssetImage('lib/Assets/google.png'),
                              alignment: Alignment.center,
                              height: 33,
                              width: 32,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                "Sign up with Google",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 20, 0),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => signUpScreen()),
                          );
                        },
                        color: const Color(0xffe1ba2d),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(
                              color: Color(0xffe1ba2d), width: 1),
                        ),
                        textColor: const Color.fromARGB(255, 0, 0, 0),
                        height: 60,
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Image(
                              image: AssetImage('lib/Assets/email.png'),
                              alignment: Alignment.center,
                              height: 33,
                              width: 32,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                "Sign up with Email",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 30, 0, 0),
                      child: Row(
                        children: [
                          const Text(
                            "Have an account already?",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(width: 2),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => logInScreen()),
                              );
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.transparent),
                              ),
                              minimumSize:
                                  MaterialStateProperty.all(const Size(20, 20)),
                            ),
                            child: const Text(
                              "Login Here",
                              style: TextStyle(color: Color(0xffe1ba2d)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Text("Developed By Marhaba Eman & Musa Raza",
                          style: TextStyle(
                              // color: appColors.appBasic,

                              )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleGooleSignIn() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }
}

Future<User?> signUpWithEmailPass(String email, String password) async {
  try {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credential.user;
  } catch (e) {
    print("Some Error Occured");
  }
  return null;
}

Future<User?> signInWithEmailPass(String email, String password) async {
  try {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential.user;
  } catch (e) {
    print("Some Error Occured");
  }
  return null;
}
