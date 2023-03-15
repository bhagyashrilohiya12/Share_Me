import 'package:cpr_user/constants/weighting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CPRLevelDetailsItem extends StatelessWidget {
  Weighting weightingLevel;
  String text;

  CPRLevelDetailsItem(this.weightingLevel, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(16, 48, 16, 0),
              decoration: BoxDecoration(color: Colors.white,
                  border: Border.all(color: findColorByWeight(weightingLevel),width: 3),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 8,),
                    Text(
                      findLabelByWeight(
                        weightingLevel,
                      ),
                      style: TextStyle(
                        color: findColorByWeight(weightingLevel),fontWeight: FontWeight.w600
                      ),
                    ),
                    SizedBox(height: 16,),
                    Text(
                      text,
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: findColorByWeight(weightingLevel),
                    border: Border.all(color: Colors.white,width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          MaterialCommunityIcons.trophy_outline,
                          size: 50,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
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
