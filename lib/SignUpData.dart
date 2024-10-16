import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prayerapp/models/UserDB.dart';
import 'package:prayerapp/onBoarding.dart';
import 'package:prayerapp/services/Database_service.dart';
import 'package:prayerapp/widgets/homeNavigation.dart';
import 'const/appColors.dart';
import 'package:prayerapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:csc_picker/csc_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SignUpData('musarazach@gmail.com'));
}

String? dropdownValue;
String? signedInUser;

class SignUpData extends StatefulWidget {
  final String userEmail;

  const SignUpData(this.userEmail, {Key? key}) : super(key: key);

  @override
  State<SignUpData> createState() => _SignUpDataState();
}

class _SignUpDataState extends State<SignUpData> {
  User? _user;
  final DatabaseService databaseService = DatabaseService();
  bool _obscureText = true;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  String? gendervalue, location;

  @override
  void initState() {
    signedInUser = widget.userEmail;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(150, 50, 0, 0),
                  child: Image.asset(
                    "lib/Assets/salat.png",
                    height: screenHeight / 4,
                    width: screenWidth / 4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 40, 20),
                  child: TextFormField(
                    controller: nameController,
                    style: GoogleFonts.roboto(color: Colors.black),
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 168, 160, 160),
                      ),
                      hintText: "Enter your Name",
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      labelText: "Name",
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 40, 20),
                  child: DropdownButtonFormField<String>(
                    icon: const Icon(Icons.male),
                    iconSize: 35,
                    iconEnabledColor: appColors.appBasic,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 168, 160, 160),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      labelText: "Gender",
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
                    value: dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        gendervalue = newValue;
                      });
                    },
                    items: <String>['Male', 'Female', 'All of the above']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 40, 20),
                  child: CSCPicker(
                    showStates: true,
          
                    showCities: true,
          
                    flagState: CountryFlag.DISABLE,
          
                    dropdownDecoration: BoxDecoration(
          
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        border:
                            Border.all(color: appColors.appBasic, width: 1)        
                    ),
                    
                    disabledDropdownDecoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border:
                            Border.all(color: appColors.appBasic, width: 1)),
          
                    countrySearchPlaceholder: "Country",
                    stateSearchPlaceholder: "State",
                    citySearchPlaceholder: "City",
          
                    countryDropdownLabel: "Country",
                    stateDropdownLabel: "State",
                    cityDropdownLabel: "City",
          
                    selectedItemStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
          
                    dropdownHeadingStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
          
                    dropdownItemStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
          
                    dropdownDialogRadius: 10.0,
          
                    searchBarRadius: 10.0,
          
                    onCountryChanged: (value) {
                      setState(() {
                        ///store value in country variable
                        countryValue = value;
                      });
                                        },
          
                    onStateChanged: (value) {
                      if (value != null) {
                        setState(() {
                          ///store value in state variable
                          stateValue = value;
                        });
                      } else {
                        print("Error: Unexpected null value for state");
                      }
                    },
          
                    onCityChanged: (value) {
                      if (value != null) {
                        setState(() {
                          ///store value in city variable
                          cityValue = value;
                        });
                      } else {
                        print("Error: Unexpected null value for city");
                      }
                    },
          
                    ///Show only specific countries using country filter
                    // countryFilter: ["United States", "Canada", "Mexico"],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 40, 20),
                  child: TextFormField(
                    controller: passwordController1,
                    obscureText: _obscureText,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: GoogleFonts.roboto(color: Colors.black),
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 168, 160, 160),
                      ),
                      hintText: "Enter your password",
                      labelStyle: GoogleFonts.roboto(
                          color: const Color.fromARGB(255, 0, 0, 0)),
                      floatingLabelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      labelText: "Password",
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            BorderSide(color: appColors.appBasic, width: 1.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            BorderSide(color: appColors.appBasic, width: 1.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            BorderSide(color: appColors.appBasic, width: 1.0),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 13, 0),
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: appColors.appBasic,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 40, 20),
                  child: TextFormField(
                    controller: passwordController2,
                    obscureText: _obscureText,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: GoogleFonts.roboto(color: Colors.black),
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 168, 160, 160),
                      ),
                      hintText: "Enter your password",
                      labelStyle: GoogleFonts.roboto(
                          color: const Color.fromARGB(255, 0, 0, 0)),
                      floatingLabelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      labelText: "Confirm Password",
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            BorderSide(color: appColors.appBasic, width: 1.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            BorderSide(color: appColors.appBasic, width: 1.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            BorderSide(color: appColors.appBasic, width: 1.0),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 13, 0),
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: appColors.appBasic,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 20, 65, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (passwordController1.text == passwordController2.text) {
                        UserDB user = UserDB(
                            userID: widget.userEmail,
                            Name: nameController.text,
                            Gender: gendervalue!);
                        databaseService.addUser(user);
                        signUp();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => homeNavigation(cityValue),
                        ));
                      } else {
                        print("Passwords do not matched");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.appBasic,
                      minimumSize: const Size(400, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Enter',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    print(widget.userEmail);
    print(passwordController1.text);

    _user =
        await signUpWithEmailPass(widget.userEmail, passwordController1.text);

    if (_user != null) {
      print("User is succesfully signed Up");
    } else {
      print("Some error happened");
    }
  }
}
