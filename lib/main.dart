import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:prayerapp/PrayerTimeCalculation.dart';
import 'package:prayerapp/firebase_options.dart';
import 'package:prayerapp/onBoarding.dart';
import 'package:prayerapp/services/Push_Notifications.dart';


late Map<String, dynamic> ?prayerTimesFirst;
User? _user;
final FirebaseAuth _auth = FirebaseAuth.instance;
final navigatorKey = GlobalKey<NavigatorState>();


Future _firebaseBackgroundMessage(RemoteMessage message) async{
  if(message.notification != null){
    print("Notification Recieved");
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prayerTimesFirst = await PrayerTimeCalculation.calculatePrayerTimes();

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  PushNotifications.init();

  PushNotifications.localNotiInit();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got a foregroung Notification");
    if(message.notification != null){
      PushNotifications.showSimpleNotification(title: message.notification!.title!, body: message.notification!.body!, payload: payloadData);
  }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);



  runApp(const fristRun());   // ONBOARDING
}




void checkAuthState() {
  _auth.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is signed out (Print statement from main)');
    } else {
      print('User is signed in (Print statement from main)');
    }
  });
}
