import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/badge.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart' hide Badge;

class RatingWaitingBadges extends StatelessWidget {
  Review review;

  RatingWaitingBadges({
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Badge(
              text: "Rating",
              ratingTextColor: CPRColors.cprButtonPink,
              rating: getRatingValue()),
          Badge(
            text: "Waiting",
            rating: getWaitingValue(),
          ),
        ],
      ),
    );
  }

  int getRatingValue() {
    /**
     //#abdo
        // review.rating?.toInt(),
     */

    if (review.rating == null) return 0;
    return review.rating!.toInt();
  }

  int getWaitingValue() {
    /**
        //#abdo
        // return review.waiting?.toInt();
     */
    if (review.waiting == null) return 0;
    return review.waiting!.toInt();
  }
}
