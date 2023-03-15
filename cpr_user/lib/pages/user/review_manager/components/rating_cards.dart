import 'package:cpr_user/helpers/user_helper.dart';
import 'package:cpr_user/pages/common/components/cpr_card.dart';
import 'package:cpr_user/providers/review_manager_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart' as p;

class RatingCards extends StatelessWidget {
  // const RatingCards({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = p.Provider.of<ReviewManagerProvider>(context);
    var sessionProvider = p.Provider.of<SessionProvider>(context, listen: false);
    return Column(
      children: <Widget>[

        //---------------------------------------------- rate waiting time

        CPRCard(
          // height: 110,
          title: Text(
            "Rate your waiting time",
            style: CPRTextStyles.cardTitleBlack,
          ),
          subtitle: Text(
            "subtitle goes here",
            style: CPRTextStyles.cardSubtitleBlack,
          ),
          backgroundColor: Colors.white,
          icon: MaterialCommunityIcons.information_outline,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: RatingBar(
              initialRating: provider.review!.rating ?? 3,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              ratingWidget: RatingWidget(
                empty: Icon(
                  MaterialCommunityIcons.star_outline,
                  color: Colors.grey,
                ),
                half: Icon(MaterialCommunityIcons.star_half),
                full: Icon(
                  MaterialCommunityIcons.star,
                  color: Colors.amber,
                ),
              ),
              onRatingUpdate: (rating) {
                provider.review!.rating = rating;
                if (provider.review!.realRating != null) {
                  provider.review!.previousRealRating = provider.review!.realRating;
                  provider.review!.realRating = findRealReviewByWeighting(sessionProvider.userLevel, review: rating);
                } else {
                  provider.review!.realRating = findRealReviewByWeighting(sessionProvider.userLevel, review: rating);
                  provider.review!.previousRealRating = provider.review!.realRating;
                }
              },
            ),
          ),
        ),


        //---------------------------------------------- rate your experiance

        CPRCard(
          // height: 140 ,
          title: Text(
            "Rate your experience",
            style: CPRTextStyles.cardTitleBlack,
          ),
          subtitle: Text(
            "subtitle goes here",
            style: CPRTextStyles.cardSubtitleBlack,
          ),
          backgroundColor: Colors.white,
          icon: MaterialCommunityIcons.information_outline,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: RatingBar(
              initialRating: provider.review!.waiting?.toDouble() ?? 3,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              ratingWidget: RatingWidget(
                full: Icon(
                  MaterialCommunityIcons.heart,
                  color: Colors.red,
                ),
                half: Icon(MaterialCommunityIcons.heart_half_full),
                empty: Icon(
                  MaterialCommunityIcons.heart_outline,
                  color: Colors.grey,
                ),
              ),
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              onRatingUpdate: (rating) {
                provider.review!.waiting = rating.toInt();
              },
            ),
          ),
        ),
      ],
    );
  }
}
