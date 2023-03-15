import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/helpers/share_helper.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/share_bottom_sheet.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;

import '../../../../helpers/social_post_helper.dart';

class ReviewSharingOptions extends StatelessWidget {
  final Review review;
  final double width;

  ReviewSharingOptions({
    // Key key,
    required this.review,
    required this.width,
  });
  // : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sessionProvider =
        p.Provider.of<SessionProvider>(context, listen: false);
    var showEdit = sessionProvider.user!.documentID == review.userID;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
//          Flexible(
//            flex: 1,
//            child: GestureDetector(
//              onTap: () {
//                showModalBottomSheet(
//                  context: context,
//                  builder: (modalContext) {
//                    return ShareBottomSheet(review);
//                  },
//                );
//                // ShareHelper.shareWithFacebook(review);
//              },
//              child: Padding(
//                padding: EdgeInsets.only(right: showEdit ? 5 : 0),
//                child: Material(
//                  color: CPRColors.cprButtonPink,
//                  borderRadius:
//                      BorderRadius.circular(CPRDimensions.miniButtonRadio),
//                  child: Container(
//                    padding: EdgeInsets.symmetric(vertical: 12),
//                    child: Center(
//                      child: Text(
//                        "Share Review",
//                        style: CPRTextStyles.buttonSmallWhite,
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          ),
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                SocialPostHelper().shareReview(review: this.review);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Material(
                  color: CPRColors.cprButtonGreen,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        "Share Review",
                        style: CPRTextStyles.buttonSmallWhite
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (showEdit)
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  CPRRoutes.editReview(context, review: this.review);
                  SocialPostHelper().editReview(review: this.review);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Material(
                    color: CPRColors.cprButtonGreen,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          "Edit Review",
                          style: CPRTextStyles.buttonSmallWhite
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
