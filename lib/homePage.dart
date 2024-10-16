// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jhijri/jHijri.dart';
import 'package:prayerapp/CountdownTimerWidget.dart';
import 'package:prayerapp/Hadith.dart';
import 'package:prayerapp/compass/loading_indicator.dart';
import 'package:prayerapp/const/appColors.dart';
import 'package:prayerapp/main.dart';
import 'package:prayerapp/services/Database_service.dart';
import 'package:prayerapp/widgets/homeNavigation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class homePageController extends GetxController {
  var dailyHadith = ''.obs;
  RxList<Hadith> hadithList = <Hadith>[].obs;
  var isCheckedbox = false.obs;
  var checkColor = Color(0xFF2E2E2E).obs;

  var bookslug = 'sahih-bukhari'.obs;
  var number = 5.obs;
  RxString? nextPrayerName = ''.obs;
  RxString? nextPrayerTime = ''.obs;
  Rx<String?> islamicDate = Rx<String?>(null); // or Rx<String?>()
  RxString? prayerNameForDB = ''.obs;
  DateTime? nextRemainingTime;
  Duration remainingTime = Duration.zero;
  late Timer _timer;

  DatabaseService _databaseService = DatabaseService();

  @override
  void onInit() {
    fetchData();
    startTimer();
    calculate();
    nextCalculate();
    updateRemainingTime();
    loadPrayerData();
    super.onInit();
  }

  String formatTime(DateTime dateTime) {
    String amPm = dateTime.hour < 12 ? 'AM' : 'PM';
    int hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    return '$hour:${dateTime.minute.toString().padLeft(2, '0')} $amPm';
  }

  void calculate() {
    final jHijri = JHijri.now();
    String digitsBetweenDashes = '';
    String digitsBeforeFirstDash = '';
    String digitsAfterSecondDash = '';
    String? monthName;

    String inputString = jHijri.fullDate;

    RegExp regExp = RegExp(r'(\d+)-(\d+)-(\d+)');

    Match? match = regExp.firstMatch(inputString) as Match?;

    if (match != null) {
      digitsBeforeFirstDash = match.group(1)!;
      digitsBetweenDashes = match.group(2)!;
      digitsAfterSecondDash = match.group(3)!;
    } else {
      print("No match found");
    }

    switch (int.parse(digitsBetweenDashes)) {
      case 1:
        monthName = 'Muharram';
        break;

      case 2:
        monthName = 'Safar';
        break;

      case 3:
        monthName = 'Rabi al-Awwal';
        break;

      case 4:
        monthName = 'Rabi al-Thani';
        break;

      case 5:
        monthName = 'Jumada al-Awwal';
        break;

      case 6:
        monthName = 'Jumada al-Thani';
        break;

      case 7:
        monthName = 'Rajab';
        break;

      case 8:
        monthName = 'Shaban';
        break;

      case 9:
        monthName = 'Ramadan';
        break;

      case 10:
        monthName = 'Shawwal';
        break;

      case 11:
        monthName = 'Dhu al-Qadah';
        break;

      case 12:
        monthName = 'Dhu al-Hijjah';
        break;
    }

    islamicDate.value =
        digitsBeforeFirstDash + ' ' + monthName! + ' ' + digitsAfterSecondDash;


    int randomBook = Random().nextInt(6) + 1;

    switch (randomBook) {
      case 1:
        bookslug.value = 'sahih-bukhari';
        number.value = Random().nextInt(56) + 1;
        break;
      case 2:
        bookslug.value = 'sahih-muslim';
        number.value = Random().nextInt(56) + 1;
        break;
      case 3:
        bookslug.value = 'al-tirmidhi';
        number.value = Random().nextInt(48) + 1;
        break;
      case 4:
        bookslug.value = 'abu-dawood';
        number.value = Random().nextInt(43) + 1;
        break;
      case 5:
        bookslug.value = 'ibn-e-majah';
        number.value = Random().nextInt(39) + 1;
        break;
      case 6:
        bookslug.value = 'sunan-nasai';
        number.value = Random().nextInt(52) + 1;
        break;
      default:
        print("Random number is out of range");
    }
  }

  void nextCalculate() {
    DateTime now = DateTime.now();

    List<String> prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    List<DateTime> prayerTimes2 = [
      prayerTimesFirst!['fajrTime'],
      prayerTimesFirst!['dhuhrTime'],
      prayerTimesFirst!['asrTime'],
      prayerTimesFirst!['maghribTime'],
      prayerTimesFirst!['ishaTime'],
    ];

    for (int i = 0; i < prayerTimes2.length; i++) {
      if (now.isBefore(prayerTimes2[i])) {
        nextPrayerName!.value = prayerNames[i];
        nextPrayerTime!.value = formatTime(prayerTimes2[i]);
        nextRemainingTime = prayerTimes2[i];
        break;
      } else if (i == prayerTimes2.length - 1) {
        nextPrayerName!.value = prayerNames[0];
        nextPrayerTime!.value =
            formatTime(prayerTimesFirst!['fajrTime'].add(Duration(days: 1)));
        nextRemainingTime =
            prayerTimesFirst!['fajrTime'].add(Duration(days: 1));
      }
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      checkNextPrayerTime();
    });
  }

  void checkNextPrayerTime() {
    DateTime now = DateTime.now();

    if (nextRemainingTime != null && now.isAfter(nextRemainingTime!)) {
      nextCalculate();
      updateRemainingTime();
      loadPrayerData();
    }
  }

  void deletePrayerData(String prayerName) async {
    String userId = loggedInUser!;
    await _databaseService.deletePrayerData(
      userId: userId,
      prayerName: prayerName,
    );
  }

  void loadPrayerData() async {
    String userId = loggedInUser!;

    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: 1));

    List<Map<String, dynamic>> prayerData = await _databaseService
        .getPrayerDataInDateRange(userId, startDate, endDate);

    updateUIWithPrayerData(prayerData);
  }

  void updateUIWithPrayerData(List<Map<String, dynamic>> prayerData) {
    for (var data in prayerData) {
      String? prayerName = data['prayerName'];
      bool isOffered = data['isOffered'];
      DateTime storedDate = (data['date'] as Timestamp).toDate();

      if (prayerName == nextPrayerName?.value &&
          isSameDay(DateTime.now(), storedDate)) {
        updateCheckboxState(prayerName, isOffered);
      }
    }
  
  }

  void updateCheckboxState(String? prayerName, bool isOffered) {
    if (prayerName == null) {
      return;
    }

    switch (prayerName) {
      case 'Fajr':
        isCheckedbox.value = isOffered;
        checkColor.value = isOffered ? appColors.appBasic : appColors.appBasic;
        break;
      case 'Zuhar':
        isCheckedbox.value = isOffered;
        checkColor.value = isOffered ? appColors.appBasic : appColors.appBasic;
        break;
      case 'Asr':
        isCheckedbox.value = isOffered;
        checkColor.value = isOffered ? appColors.appBasic : appColors.appBasic;
        break;
      case 'Maghrib':
        isCheckedbox.value = isOffered;
        checkColor.value = isOffered ? appColors.appBasic : appColors.appBasic;
        break;
      case 'Isha':
        isCheckedbox.value = isOffered;
        checkColor.value = isOffered ? appColors.appBasic : appColors.appBasic;
        break;
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void savePrayerData(String prayerName, bool isOffered) async {
    String userId = loggedInUser!;
    await _databaseService.addPrayerData(
      userId: userId,
      prayerName: prayerName,
      isOffered: isOffered,
    );
  }

  void updateRemainingTime() {
    if (nextRemainingTime == null) {
      return;
    }
    remainingTime = calculateRemainingTime();
  }

  Duration calculateRemainingTime() {
    DateTime now = DateTime.now();
    if (nextRemainingTime == null) {
      return Duration.zero;
    }
    return nextRemainingTime!.difference(now);
  }

  void fetchData() async {
    var apiKey =
        '\$2y\$10\$EKIdJOrdsb3yxKEZYyWlte2WdRm8R0rtGJYiTGRKvm1ZvWhz39e';
    var response = await http.get(Uri.parse(
        "https://hadithapi.com/public/api/hadiths?apiKey=$apiKey&book=$bookslug&chapter=$number&paginate=1"));

    if (response.statusCode == 200) {
      final dynamic responseData = jsonDecode(response.body);

      List datalist = responseData["hadiths"]["data"];

      hadithList.value =
          datalist.map((element) => Hadith.fromJson(element)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class HomePage extends StatelessWidget {
  final String? userLocation;
  HomePage({this.userLocation, Key? key}) : super(key: key);

  final homePageController _controller = Get.put(homePageController());

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E2E2E),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: 350.0,
                      height: 200.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Obx(
                                  () => Text(
                                    '${_controller.islamicDate.value}',
                                    style: const TextStyle(
                                      color: Color(0xffe1ba2d),
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                child: Container(
                                  width: 110,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            icon:
                                                const Icon(Icons.location_pin),
                                            color: appColors.appBasic,
                                            iconSize: 25,
                                            onPressed: () {},
                                          ),
                                          Text(
                                            userLocation!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 0),
                                        child: Obx(
                                          () => Text(
                                            _controller.nextPrayerName!.value,
                                            style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 0),
                                        child: Obx(
                                          () => Text(
                                            _controller.nextPrayerTime!.value,
                                            style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Obx(
                                          () => Checkbox(
                                            value:
                                                _controller.isCheckedbox.value,
                                            activeColor:
                                                _controller.checkColor.value,
                                            side: const BorderSide(
                                                color: Colors.white),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            onChanged: (value) async {
                                              _controller.isCheckedbox.value =
                                                  value!;
                                              _controller.checkColor.value =
                                                  value
                                                      ? appColors.appBasic
                                                      : const Color.fromARGB(
                                                          255, 45, 38, 38);

                                              if (value) {
                                                await _controller
                                                    ._databaseService
                                                    .addPrayerData(
                                                  userId: loggedInUser!,
                                                  prayerName: _controller
                                                      .nextPrayerName!.value,
                                                  isOffered: value,
                                                );
                                              } else {
                                                await _controller
                                                    ._databaseService
                                                    .deletePrayerData(
                                                  userId: loggedInUser!,
                                                  prayerName: _controller
                                                      .nextPrayerName!.value,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(130, 0, 0, 0),
                                child: CountdownTimerWidget(
                                    duration: _controller.remainingTime),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: 350.0,
                      height: screenHeight / 2 - 100,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text('Hadith of the day \n',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    color: appColors.appBasic,
                                  )),
                            ),
                            Obx(
                              () => Text(
                                'Book: ${_controller.bookslug.value} \n',
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            Obx(
                              () {
                                if (_controller.hadithList.isNotEmpty) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hadith Number: ${_controller.hadithList[0].hadithNumber} \n',
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '"${_controller.hadithList[0].hadithEnglish}"',
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                      child: LoadingIndicator());
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
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
}
