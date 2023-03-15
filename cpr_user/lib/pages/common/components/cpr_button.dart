import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';

class CPRButton extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  final double verticalPadding;
  final double horizontalPadding;
  double? height;
  double? width;
  final double borderRadius;
  final Color color;

  CPRButton(
      {
       this.height,
         this.width,
        required this.onPressed,
        required this.child,
      this.borderRadius = 20,
      this.color = CPRColors.cprButtonGreen,
      this.horizontalPadding = 30,
      this.verticalPadding = 20}) ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: height,
        width: width,
        child: Material(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          color: color,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
