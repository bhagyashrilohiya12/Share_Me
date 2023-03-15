import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CPRLogo extends StatelessWidget {
    CPRLogo({ this.widgetSize = 80})  ;
  final double widgetSize;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage("assets/images/ic_logo.png"),
      width: Get.width * 2 / 3,
      fit: BoxFit.contain,
    );
  }
}
