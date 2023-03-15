import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';

class CPRPageTitle extends StatelessWidget {
   CPRPageTitle({

    required this.title,
  })  ;

  final String title;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        //width: width,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  title ,
                  style: CPRTextStyles.clickPickReviewStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
