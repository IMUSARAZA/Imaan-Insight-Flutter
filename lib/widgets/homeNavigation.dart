import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:prayerapp/MasjidLocator.dart';
import 'package:prayerapp/PrayerTimeCalculation.dart';
import 'package:prayerapp/const/appColors.dart';
import 'package:prayerapp/homePage.dart';
import 'package:prayerapp/onBoarding.dart';
import 'package:prayerapp/prayerRecordScreen.dart';
import 'package:prayerapp/qiblaFinder.dart';


String? loggedInUser = FirebaseAuth.instance.currentUser!.email!;



class homeNavigation extends StatefulWidget {
  final String location;
  const homeNavigation(this.location, {Key? key}) : super(key: key);

  @override
  State<homeNavigation> createState() => _homeNavigationState();
}

class _homeNavigationState extends State<homeNavigation> {
  int _selectedIndex = 0;
  late HomePage _homePage;
  late MapPage _mapPage;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    _homePage = HomePage(userLocation: widget.location);
    _mapPage = MapPage(position!.latitude, position!.longitude);

    final screens = [
      _homePage,
      const PrayerRecordScreen(),
      const qiblaFinder(),
      _mapPage,
    ];

    return Scaffold(
  body: screens[_selectedIndex],
  appBar: AppBar(
    shadowColor: const Color(0xffe1ba2d),
    leading: const SizedBox(),
    backgroundColor: appColors.appBasic,
    title: const Center(
      child: Text(
        'Iman Insight',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.person),
        color: const Color(0xFF4137BD),
        iconSize: 30,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Dismiss the dialog
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      FirebaseAuth _auth = FirebaseAuth.instance;
                      await _auth.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const onBoarding()),
                      );
                    },
                    child: const Text('Logout'),
                  ),
                ],
              );
            },
          );
        },
      ),
    ],
  ),

        bottomNavigationBar: Container(
          height: 75,
          width: screenWidth,
          decoration: const BoxDecoration(
            color: appColors.appBasic,
            border: Border(
              top: BorderSide(
                color: appColors.appBasic,
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FlutterIslamicIcons.prayingPerson),
                  label: 'Prayer Record',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.compass),
                  label: 'Qibla',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FlutterIslamicIcons.mosque),
                  label: 'Masjid Locator',
                ),
                
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: appColors.appBasic,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
    );
  }
}
