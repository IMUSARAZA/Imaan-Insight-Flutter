import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prayerapp/const/appColors.dart';
import 'package:prayerapp/main.dart';
import 'package:prayerapp/services/Database_service.dart';
import 'package:prayerapp/widgets/homeNavigation.dart';

void main() {
  runApp(const PrayerRecordScreen());
}

class PrayerRecordScreen extends StatefulWidget {
  const PrayerRecordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PrayerRecordScreen> createState() => _PrayerRecordScreenState();
}

class _PrayerRecordScreenState extends State<PrayerRecordScreen> {
  late String? fajarTime, zuharTime, asarTime, maghribTime, ishaTime;

  bool isCheckedbox1 = false;
  bool isCheckedbox2 = false;
  bool isCheckedbox3 = false;
  bool isCheckedbox4 = false;
  bool isCheckedbox5 = false;

  Color checkColor1 = Colors.black;
  Color checkColor2 = Colors.black;
  Color checkColor3 = Colors.black;
  Color checkColor4 = Colors.black;
  Color checkColor5 = Colors.black;

  late DatabaseService _databaseService;

  List<Map<String, dynamic>> _cachedPrayerData = [];
  Map<String, double> _dailyAverages = {};

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService();
    prayerTimesDislay();
    loadPrayerData();
  }

  // Add a method to delete prayer data
  void deletePrayerData(String prayerName) async {
    String userId = loggedInUser!;
  await _databaseService.deletePrayerData(
    userId: userId,
    prayerName: prayerName,
  );
}


  void loadPrayerData() async {
    String userId = loggedInUser!;
    if (_cachedPrayerData.isNotEmpty) {
      updateUIWithPrayerData(_cachedPrayerData);
    }

    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: 6));

    List<Map<String, dynamic>> prayerData =
        await _databaseService.getPrayerDataInDateRange(userId, startDate, endDate);
    print("Retrieved Prayer Data: $prayerData");

    updateUIWithPrayerData(prayerData);
    _cachedPrayerData = prayerData;

    calculateDailyAverages();

    setState(() {
      
    });
  }



  void prayerTimesDislay() {
    fajarTime = formatTime(prayerTimesFirst!['fajrTime']);
    zuharTime = formatTime(prayerTimesFirst!['dhuhrTime']);
    asarTime = formatTime(prayerTimesFirst!['asrTime']);
    maghribTime = formatTime(prayerTimesFirst!['maghribTime']);
    ishaTime = formatTime(prayerTimesFirst!['ishaTime']);
  }

  String formatTime(DateTime dateTime) {
    String amPm = dateTime.hour < 12 ? 'AM' : 'PM';
    int hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    return '$hour:${dateTime.minute.toString().padLeft(2, '0')} $amPm';
  }

  


  

  void updateUIWithPrayerData(List<Map<String, dynamic>> prayerData) {
    for (var data in prayerData) {
      String prayerName = data['prayerName'];
      bool isOffered = data['isOffered'];
      DateTime storedDate = (data['date'] as Timestamp).toDate();

      if (isSameDay(DateTime.now(), storedDate)) {
        updateCheckboxState(prayerName, isOffered);
      }
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
  // print('Date1: $date1, Date2: $date2');
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

  void resetCheckboxStates() {
    setState(() {
      isCheckedbox1 = false;
      isCheckedbox2 = false;
      isCheckedbox3 = false;
      isCheckedbox4 = false;
      isCheckedbox5 = false;

      checkColor1 = Colors.black;
      checkColor2 = Colors.black;
      checkColor3 = Colors.black;
      checkColor4 = Colors.black;
      checkColor5 = Colors.black;
    });
  }

  void updateCheckboxState(String prayerName, bool isOffered) {
    switch (prayerName) {
      case 'Fajr':
        setState(() {
          isCheckedbox1 = isOffered;
          checkColor1 = isOffered ? appColors.appBasic : appColors.appBasic;
        });
        break;
      case 'Zuhar':
        setState(() {
          isCheckedbox2 = isOffered;
          checkColor2 = isOffered ? appColors.appBasic : appColors.appBasic;
        });
        break;
      case 'Asr':
        setState(() {
          isCheckedbox3 = isOffered;
          checkColor3 = isOffered ? appColors.appBasic : appColors.appBasic;
        });
        break;
      case 'Maghrib':
        setState(() {
          isCheckedbox4 = isOffered;
          checkColor4 = isOffered ? appColors.appBasic : appColors.appBasic;
        });
        break;
      case 'Isha':
        setState(() {
          isCheckedbox5 = isOffered;
          checkColor5 = isOffered ? appColors.appBasic : appColors.appBasic;
        });
        break;
    }
  }

  void savePrayerData(String prayerName, bool isOffered) async {
    String userId = loggedInUser!;
    await _databaseService.addPrayerData(
      userId: userId,
      prayerName: prayerName,
      isOffered: isOffered,
    );
  }

   void calculateDailyAverages() {
    DateTime today = DateTime.now();
    _dailyAverages = {}; 

    for (int i = 0; i < 7; i++) {
      DateTime date = today.subtract(Duration(days: i));
      double average = calculateAverageForDay(date);

      _dailyAverages[getDayName(date)] = average;
    }

    setState(() {});
  }

  double calculateAverageForDay(DateTime date) {
  DateTime dateWithoutTime = DateTime(date.year, date.month, date.day);

  List<Map<String, dynamic>> prayersForDay = _cachedPrayerData
      .where((data) => isSameDay(dateWithoutTime, (data['date'] as Timestamp).toDate()))
      .toList();

  if (prayersForDay.isEmpty) {
    return 0.0;
  }

  int totalPrayers = 5; // Fixed number of prayers per day
  int completedPrayers =
      prayersForDay.where((data) => data['isOffered']).length;

  print('Date: $dateWithoutTime, Completed Prayers: $completedPrayers');

  return completedPrayers / totalPrayers;
}





  String getDayName(DateTime date) {
  return DateFormat('EEE').format(date);
}


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 15),
                child: Text(
                  "Today",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: appColors.appBasic,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              buildPrayerRow("Fajr", "$fajarTime.", isCheckedbox1, checkColor1,
                  (value, color) {
                setState(() {
                  isCheckedbox1 = value;
                  checkColor1 = value ? appColors.appBasic : appColors.appBasic;
                });
              }),
              buildPrayerRow("Zuhar", "$zuharTime.", isCheckedbox2, checkColor2,
                  (value, color) {
                setState(() {
                  isCheckedbox2 = value;
                  checkColor2 = value ? appColors.appBasic : appColors.appBasic;
                });
              }),
              buildPrayerRow("Asr", "$asarTime.", isCheckedbox3, checkColor3,
                  (value, color) {
                setState(() {
                  isCheckedbox3 = value;
                  checkColor3 = value ? appColors.appBasic : appColors.appBasic;
                });
              }),
              buildPrayerRow(
                  "Maghrib", "$maghribTime.", isCheckedbox4, checkColor4,
                  (value, color) {
                setState(() {
                  isCheckedbox4 = value;
                  checkColor4 = value ? appColors.appBasic : appColors.appBasic;
                });
              }),
              buildPrayerRow("Isha", "$ishaTime.", isCheckedbox5, checkColor5,
                  (value, color) {
                setState(() {
                  isCheckedbox5 = value;
                  checkColor5 = value ? appColors.appBasic : appColors.appBasic;
                });
              }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E2E2E),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        width: screenWidth / 2 + 150,
                        height: MediaQuery.of(context).size.height / 2 - 170,
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Text(
                                      'Prayer stats of the current week',
                                      style: GoogleFonts.roboto(
                                        color: appColors.appBasic,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              buildLinearProgress(
                                  "Sun", _dailyAverages["Sun"] ?? 0.0),
                              buildLinearProgress(
                                  "Mon", _dailyAverages["Mon"] ?? 0.0),
                              buildLinearProgress(
                                  "Tue", _dailyAverages["Tue"] ?? 0.0),
                              buildLinearProgress(
                                  "Wed", _dailyAverages["Wed"] ?? 0.0),
                              buildLinearProgress(
                                  "Thu", _dailyAverages["Thu"] ?? 0.0),
                              buildLinearProgress(
                                  "Fri", _dailyAverages["Fri"] ?? 0.0),
                              buildLinearProgress(
                                  "Sat", _dailyAverages["Sat"] ?? 0.0),
                            ],
                          ),
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

  Widget buildPrayerRow(
    String prayerName,
    String prayerTime,
    bool isChecked,
    Color checkColor,
    void Function(bool, Color) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 30, 0),
          child: Transform.scale(
            scale: 1.5,
            child: Checkbox(
              value: isChecked,
              activeColor: checkColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
                side: BorderSide(color: appColors.appBasic),
              ),
              onChanged: (value) async {
                onChanged(value!, checkColor);

                // If the checkbox is unchecked, delete the entry from Firestore
                if (!value) {
                  deletePrayerData(prayerName);
                } else {
                  // If the checkbox is checked, save the entry to Firestore
                  savePrayerData(prayerName, value);
                }
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Text(
              prayerName,
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Text(
              prayerTime,
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLinearProgress(String title, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
          child: Text(
            title,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 10,
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(20.0),
                value: value,
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation(
                  appColors.appBasic,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}