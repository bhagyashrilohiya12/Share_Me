import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CPRTextStyles {
  //Review Styles
  static const TextStyle reviewCardStarsTextStyle = TextStyle(
      color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12);
  static const TextStyle reviewCardContentTextStyle = TextStyle(
      color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12);
  static const TextStyle reviewCardReviewerTextStyle = TextStyle(
      color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12);

  static const TextStyle avatarProfileNameStyle =
  TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

  static const TextStyle avatarProfileNameStyleBlack =
  TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

  static const TextStyle reviewRateStyle =
  TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

  static const TextStyle clickPickReviewStyle =
  TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  static const TextStyle cardTitle =
  TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  static const TextStyle cardTitleBlack =
  TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  static TextStyle cardSubtitle =
  TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10);
  static TextStyle cardSubtitleBlack =
  TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 10);
  static TextStyle buttonSmallWhite = TextStyle(
      color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold);
  static TextStyle buttonMediumWhite =
  TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold);
  static TextStyle smallHeaderBoldDarkBackground =
  TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold);
  static TextStyle smallHeaderNormalDarkBackground = TextStyle(
      color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal);

  static const TextStyle ratingTextStyle =
  TextStyle(fontSize: 50, fontWeight: FontWeight.bold);

  static const TextStyle logoStyle = TextStyle(
    fontFamily: "Mexcellent",
    color: Colors.white,
    fontSize: 80,
  );
}

class CPRColors {
  static const Color cprButtonPink = Color.fromRGBO(229, 45, 140, 1);
  static  HexColor pink_hex = HexColor( "#E52D8C");

  static const Color cprButtonGreen = Color.fromRGBO(32, 211, 35, 1); //20D323
  static  HexColor green_hex = HexColor( "#20D323");

  static const Color facebookBlue = Color.fromRGBO(66, 90, 153, 1);
  static const Color twitterBlue = Color.fromRGBO(29, 161, 242, 1);
  static const Color googleRed = Color.fromRGBO(219, 68, 55, 1);
  static const Color backgroundColor = Colors.black;
  static const Color grayLight = Color(0xffefefef);
  static const Color grayMedium = Color(0xfcdcdcd);

  static const Color appBarBackground = Colors.black;
  static const Color appBarBackButtonColor = Colors.black;
}

class CPRInputDecorations {
  static final InputDecoration cprFilter = InputDecoration(
    border: InputBorder.none,
    hintText: "Filter Results",
    contentPadding: EdgeInsets.fromLTRB(16,4,16,4),
  );

  static const InputDecoration cprFormInput = InputDecoration(
    border: InputBorder.none,
    hintText: "",
    contentPadding: EdgeInsets.all(8),
  );
  static const InputDecoration cprInput = InputDecoration(
    border: OutlineInputBorder(),
    hintText: "Filter Results",
    contentPadding: EdgeInsets.all(8),
  );
}

class CPRDimensions {
  static const double miniButtonRadio = 15;
  static const double loginTextFieldRadius = 15;
  static const double homeMarginBetweenCard = 10;
  static const double buttonMediumRadius = 12;
  static const double bigIconSize = 58;
}
