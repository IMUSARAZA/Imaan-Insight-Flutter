import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe1ba2d))),
      );
}