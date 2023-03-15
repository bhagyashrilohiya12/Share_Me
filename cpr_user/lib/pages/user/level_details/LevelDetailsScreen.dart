import 'package:cpr_user/constants/weighting.dart';
import 'package:cpr_user/pages/user/level_details/components/cpr_level_details_item.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

class LevelDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Log.i( "page  - LevelDetailsScreen - build");

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            decoration:BoxDecoration(
              color: Colors.black
            )
          ),
          Positioned(
            top: 50,
            right: 16,
            height: 42,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black
                ),child: Image(
                image: AssetImage(
                  "assets/images/ic_cpr_level_title.png",
                ),
                height: 36,
              ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Row(
              children: <Widget>[
                Material(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 112, 16, 16),
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CPRLevelDetailsItem(Weighting.platinum,
                      "You are a treasure, full of life and love helping others make better decisions in their choices.  There are exclusive Platinum only secrets that you will become privy too."),
                  Divider(),
                  CPRLevelDetailsItem(Weighting.gold,
                      "With an abundance of coins and reviews you are great at what you do.  Keep going and you might make Platinum unlocking new and secret benefits."),
                  Divider(),
                  CPRLevelDetailsItem(Weighting.silver, "Trade in your silver for gold review review review."),
                  Divider(),
                  CPRLevelDetailsItem(Weighting.bronze,
                      "Learn how to earn the most out of ClickPicReview click here for more information."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
