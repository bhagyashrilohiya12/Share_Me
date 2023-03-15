import 'package:cpr_user/constants/weighting.dart';
import 'package:cpr_user/pages/user/level_details/LevelDetailsScreen.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;

class CPRLevel extends StatelessWidget {
  // const CPRLevel({
  //   Key key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 24, bottom: 0),
          child: Image(
            image: AssetImage(
              "assets/images/ic_cpr_level_title.png",
            ),
            height: 36,
          ),
        ),
        p.Consumer<SessionProvider>(builder: (context, provider, _) {
          Color color = findColorByWeight(provider.userLevel);
          String levelName = findLabelByWeight(provider.userLevel);
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 8),
                child: CircleAvatar(
                  backgroundColor: Color(0xffd1dee3),
                  radius: 35,
                  child: Image(
                    image: AssetImage(
                      "assets/images/ic_bronze-_level.png",
                    ),
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  levelName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: Colors.white
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(bottom: 16,right: 32,left: 32),
                  child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "The more reviews you do, the higher you climb with better prizes. ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                            ),
                          ),
                          TextSpan(
                            text: 'Find out more',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Get.theme.accentColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context, new MaterialPageRoute(builder: (context) => LevelDetailsScreen()));
                              },
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center))
            ],
          );
        }),
      ],
    );
  }

  Color findColorByWeight(Weighting userLevel) {
    switch (userLevel) {
      case Weighting.platinum:
      return Color(0xff98989C);
      case Weighting.gold:
        return Colors.amber;
      case Weighting.silver:
        return Colors.grey;
      default:
        return Colors.brown;
    }
  }

  String findLabelByWeight(Weighting userLevel) {
    switch (userLevel) {
      case Weighting.platinum:
        return "Platinum";
      case Weighting.gold:
        return "Gold";
      case Weighting.silver:
        return "Silver";
      default:
        return "Bronze";
    }
  }
}
