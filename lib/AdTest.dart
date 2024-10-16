// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await MobileAds.instance.initialize();
//   var devices = ["3E4C94C154695F9312E77C36627C8A0F"];
//   RequestConfiguration requestConfiguration = RequestConfiguration(testDeviceIds: devices);

//   MobileAds.instance.updateRequestConfiguration(requestConfiguration);
//   runApp(AdTest());

// }
// class AdTest extends StatefulWidget {
//   const AdTest({super.key});

//   @override
//   State<AdTest> createState() => _AdTestState();
// }

//   late BannerAd bannerAd;
//   bool isAdLoaded = false;
//   var adUnit = 'ca-app-pub-3940256099942544/6300978111';
// class _AdTestState extends State<AdTest> {

//   @override
//   void initState() {
//     initBannerAd();
//     super.initState();
    
//   }

//   initBannerAd(){
//     bannerAd = BannerAd(
//       size: AdSize.banner,
//       adUnitId: adUnit,
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           setState(() {
//            isAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//           print("Error in loading ad");
//         }, 
//       ),
//       request: const AdRequest(),
//     );

//     bannerAd.load();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Text("HI"),
//         bottomNavigationBar: isAdLoaded ? SizedBox(
//                         height:bannerAd.size.height.toDouble(),
//                         width: bannerAd.size.width.toDouble(),
//                         child: AdWidget(ad: bannerAd),
//                       ) : const SizedBox(),
//       ),
//     );
//   }
// }