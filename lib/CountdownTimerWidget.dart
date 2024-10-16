import 'package:flutter/material.dart';
import 'package:prayerapp/const/appColors.dart';

class CountdownTimerWidget extends StatefulWidget {
  final Duration duration;

  const CountdownTimerWidget({Key? key, required this.duration})
      : super(key: key);

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late double progress;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    controller.addListener(() {
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
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
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(appColors.appBasic),
              backgroundColor: Colors.white,
              value: progress,
              strokeWidth: 3,
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
    );
  }

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
