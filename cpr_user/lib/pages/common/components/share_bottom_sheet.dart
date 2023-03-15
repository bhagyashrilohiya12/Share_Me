import 'package:cpr_user/helpers/share_helper.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/cpr_header.dart';
import 'package:cpr_user/pages/common/components/cpr_separator.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ShareBottomSheet extends StatelessWidget {
    Review review;
    BuildContext closeableContext;

    ShareBottomSheet(this.review, {required this.closeableContext});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: <Widget>[
          CPRHeader(
            height: 48,
            icon: CupertinoIcons.share_up,
            title: Text(
              "Share review",
              style: CPRTextStyles.cardTitle,
            ),
            subtitle: Text(
              "Select how you want to share this review.",
              style: CPRTextStyles.cardSubtitle,
            ),
          ),
          CPRSeparator(),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    await ShareHelper.shareWithFacebook(review);
                    if (closeableContext != null) {
                      Navigator.pop(context);
                      Navigator.pop(closeableContext);
                    }
                  },
                  child: Column(
                    children: const <Widget>[
                      Icon(
                        MaterialCommunityIcons.facebook,
                        size: CPRDimensions.bigIconSize,
                      ),
                      Text("Facebook", style: CPRTextStyles.cardTitle)
                    ],
                  ),
                ),
//                FlatButton(
//                  onPressed: () async {
//                    await ShareHelper.shareWithInstagram(review);
//                    if (closeableContext != null) {
//                      Navigator.pop(context);
//                      Navigator.pop(closeableContext);
//                    }
//                  },
//                  child: Column(
//                    children: <Widget>[
//                      Icon(
//                        MaterialCommunityIcons.getIconData("instagram"),
//                        size: CPRDimensions.bigIconSize,
//                      ),
//                      Text("Instagram", style: CPRTextStyles.cardTitle)
//                    ],
//                  ),
//                ),
                TextButton(
                  onPressed: () async {
                    await ShareHelper.shareWithSystemUI(review);
                    if (closeableContext != null) {
                      Navigator.pop(context);
                      Navigator.pop(closeableContext);
                    }
                  },
                  child: Column(
                    children: const <Widget>[
                      Icon(
                        MaterialCommunityIcons.settings,
                        size: CPRDimensions.bigIconSize,
                      ),
                      Text(
                        "System",
                        style: CPRTextStyles.cardTitle,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
