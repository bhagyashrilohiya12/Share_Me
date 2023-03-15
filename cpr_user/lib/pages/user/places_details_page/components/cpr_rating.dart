import 'package:cpr_user/helpers/number_helper.dart';
import 'package:cpr_user/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CPRRating extends StatelessWidget {
  Place place;

  CPRRating(this.place);

  @override
  Widget build(BuildContext context) {
    try {
      if (place != null && place.totalReviews != null && place.totalRating != null && place.totalReviews!>0) {
        double realRating = NumberHelper.roundTo(place.totalRating / place.totalReviews);
        if (realRating > 5) {
          realRating = 5;
        }
        double cprRating = realRating.isNaN ? 0 : realRating;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16,0,16,8),
          child: RatingBarIndicator(
            rating: cprRating,
            unratedColor: Colors.grey,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 24.0,
            direction: Axis.horizontal,
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    return Container();
  }


}
