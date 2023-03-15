import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final double size;
  final int rating;
  final Color background;
  final Color ratingTextColor;
  final String text;
   String? decimalRatingText;

  Badge({
    required this.text,
    this.size = 70,
    this.rating = 0,
    this.ratingTextColor = CPRColors.cprButtonGreen,
    this.background = Colors.white,
     this.decimalRatingText
  });

  @override
  Widget build(BuildContext context) {
    var widget;
    if(decimalRatingText!=null){
      widget = Container(
        padding: EdgeInsets.only(top: 15),
        child: Text(
          decimalRatingText??"",
          style: CPRTextStyles.ratingTextStyle.copyWith(color: ratingTextColor, fontSize: 30),
        ),
      );
    }else{
      widget = Text(
        "${rating}",
        style: CPRTextStyles.ratingTextStyle.copyWith(color: ratingTextColor),
      );
    }
    return Container(
      height: size + 10,
      width: size + 10,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      child: Column(
        children: <Widget>[
          widget,
          Container(
            decoration: BoxDecoration(
                color: ratingTextColor,
                borderRadius: BorderRadius.circular(10)),
            height: 20,
            width: double.infinity,
            child: Center(
                child: Text(
              text,
              style: CPRTextStyles.buttonSmallWhite.copyWith(fontSize: 12),
            )),
          )
        ],
      ),
    );
  }
}
