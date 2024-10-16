import 'package:flutter/material.dart';
import 'package:prayerapp/const/appColors.dart';



class customButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const customButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.appBasic,
                    minimumSize: const Size(400, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30.0), 
                    ),
                    elevation: 5, 
                  ),
                  onPressed: onPressed,
                  child: Text(
                    title,
                    style: const TextStyle(),
                  ),
    );
  }
}