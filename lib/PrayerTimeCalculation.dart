// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:adhan_dart/adhan_dart.dart';
import 'package:geolocator/geolocator.dart';


Position? position;
class PrayerTimeCalculation{

  
  static Future<Map<String, dynamic>> calculatePrayerTimes() async {
  WidgetsFlutterBinding.ensureInitialized();  
  tz.initializeTimeZones();
  final geolocator = GeolocatorPlatform.instance;

  // Detect coordinates
  position = await geolocator.getCurrentPosition();
  Coordinates coordinates = Coordinates(position!.latitude, position!.longitude);
  print(position!.latitude);
  print(position!.longitude);




  const MethodChannel channel = MethodChannel('flutter_native_timezone');
    final String? localTimezone = await channel.invokeMethod("getLocalTimezone");
    print(localTimezone);
        final location = tz.getLocation(localTimezone!);

  CalculationParameters params = CalculationMethod.karachi();
  params.madhab = Madhab.hanafi;
   PrayerTimes prayerTimes = PrayerTimes(calculationParameters: params, coordinates: coordinates, date: DateTime.now());


  DateTime fajrTime = tz.TZDateTime.from(prayerTimes.fajr!, location);
  DateTime sunriseTime = tz.TZDateTime.from(prayerTimes.sunrise!, location);
  DateTime dhuhrTime = tz.TZDateTime.from(prayerTimes.dhuhr!, location);
  DateTime asrTime = tz.TZDateTime.from(prayerTimes.asr!, location);
  DateTime maghribTime = tz.TZDateTime.from(prayerTimes.maghrib!, location);
  DateTime ishaTime = tz.TZDateTime.from(prayerTimes.isha!, location);

  DateTime ishabeforeTime =
      tz.TZDateTime.from(prayerTimes.ishabefore!, location);
  DateTime fajrafterTime = tz.TZDateTime.from(prayerTimes.fajrafter!, location);

  String current =
      prayerTimes.currentPrayer(date: DateTime.now()); 
  DateTime? currentPrayerTime = prayerTimes.timeForPrayer(current);
  String next = prayerTimes.nextPrayer();
  DateTime? nextPrayerTime = prayerTimes.timeForPrayer(next);

  // Sunnah Times
  SunnahTimes sunnahTimes = SunnahTimes(prayerTimes);
  DateTime middleOfTheNight =
      tz.TZDateTime.from(sunnahTimes.middleOfTheNight, location);
  DateTime lastThirdOfTheNight =
      tz.TZDateTime.from(sunnahTimes.lastThirdOfTheNight, location);

  // Qibla Direction
  var qiblaDirection = Qibla.qibla(coordinates);

  final date = DateTime.now();
  // print('***** Current Time');
  // print('local time:\t$date');

  // print('\n***** Prayer Times');
  // print('fajrTime:\t$fajrTime');
  // print('sunriseTime:\t$sunriseTime');
  // print('dhuhrTime:\t$dhuhrTime');
  // print('asrTime:\t$asrTime');
  // print('maghribTime:\t$maghribTime');
  // print('ishaTime:\t$ishaTime');

  // print('ishabeforeTime:\t$ishabeforeTime');
  // print('fajrafterTime:\t$fajrafterTime');

  // print('\n***** Convenience Utilities');
  // print('current:\t$current\t$currentPrayerTime');
  // print('next:   \t$next\t$nextPrayerTime');

  // print('\n***** Sunnah Times');
  // print('middleOfTheNight:  \t$middleOfTheNight');
  // print('lastThirdOfTheNight:  \t$lastThirdOfTheNight');

  // print('\n***** Qibla Direction');
  // print('qibla:  \t$qiblaDirection');


   Map<String, dynamic> result = {
      'fajrTime': fajrTime,
      'sunriseTime': sunriseTime,
      'dhuhrTime': dhuhrTime,
      'asrTime': asrTime,
      'maghribTime': maghribTime,
      'ishaTime': ishaTime,
      'qiblaDirection': qiblaDirection,
    };

    return result;



}

}


