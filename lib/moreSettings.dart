import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:prayerapp/const/customButton.dart';
import 'package:prayerapp/onBoarding.dart';
import 'package:prayerapp/services/Push_Notifications.dart';


class moreSettings extends StatefulWidget {
  const moreSettings({super.key});

  @override
  State<moreSettings> createState() => _moreSettingsState();
}

class _moreSettingsState extends State<moreSettings> {
  late BannerAd bannerAd;
  bool isAdLoaded = false;
  var adUnit = 'ca-app-pub-3940256099942544/6300978111';

  @override
  void initState() {
    // initBannerAd();
    super.initState();
  }

  // @override
  // void dispose(){
  //   super.dispose();
  //   bannerAd.dispose();

  // }
  initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnit,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print("Error in loading ad");
        },
      ),
      request: const AdRequest(),
    );

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              isAdLoaded
                  ? SizedBox(
                      height: bannerAd.size.height.toDouble(),
                      width: bannerAd.size.width.toDouble(),
                      child: AdWidget(ad: bannerAd),
                    )
                  : const SizedBox(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
                child: Container(
                  height: 50,
                  width: 200,
                  child: customButton(
                    title: "View Advertisement",
                    onPressed: () {
                      initBannerAd();
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Container(
                  height: 50,
                  width: 200,
                  child: customButton(
                    title: "Send a Notification",
                    onPressed: () {
                      PushNotifications.init();
                      PushNotifications.showSimpleNotification(
                        title: 'Imaan Insight!!',
                        body: 'Salah time! Turn to Allah!',
                        payload: 'Notification Payload',
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Container(
                  height: 50,
                  width: 200,
                  child: customButton(
                    title: "Logout",
                    onPressed: () async {
                      signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => onBoarding()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> signOut() async {
  await _auth.signOut();
}

// GoogleSignIn _googleSignIn = GoogleSignIn();

// Future<void> signOutGoogle() async {
//   await _googleSignIn.signOut();
//   // You may also need to clear any cached user data or navigate to the login screen.
// }

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Notification Recieved");
  }
}
