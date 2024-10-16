import 'package:flutter/cupertino.dart';
import 'package:prayerapp/const/appColors.dart';
import 'package:flutter/material.dart';


class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with TickerProviderStateMixin {
  late AnimationController controller;

  bool isPlaying = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  

 @override
void initState() {
  super.initState();
  controller = AnimationController(
    vsync: this,
    duration: Duration(hours: 1),
  );

  controller.addListener(() {
    if (controller.isAnimating) {
      setState(() {
        progress = controller.value;
      });
    } else {
      setState(() {
        progress = 1.0;
        isPlaying = false;
      });
    }
  });

  controller.reverse(from: 1.0);
}



  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      backgroundColor: Color(0xFF1C2757),
      body: Column(
        children: [
          
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 90,
                  height: 90,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(appColors.appBasic),
                    backgroundColor: Colors.white,
                    value: progress,
                    strokeWidth: 4,
                  ),
                ),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) => Text(
                    countText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}

