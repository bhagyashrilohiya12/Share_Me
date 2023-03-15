import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/common/components/cpr_card.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HistoryCard extends StatelessWidget {
  final Place? place;
  final bool? usePromotion;

  const HistoryCard({
    this.place,
    this.usePromotion,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CPRCard(
      halfScreenHeight: false,
      backgroundColor: Colors.white,
      title: const Text(
        "Were you here recently?",
        style: CPRTextStyles.cardTitleBlack,
      ),
      subtitle: Text(
        "Share your experience. Review this place",
        style: CPRTextStyles.cardSubtitleBlack,
      ),
      iconOnClick: (){
        CPRRoutes.createReview(context, place: place,usePromotion:usePromotion);
      },
      icon: MaterialCommunityIcons.history,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CPRButton(
          borderRadius: CPRDimensions.buttonMediumRadius,
          width: MediaQuery.of(context).size.width / 2,
          color: CPRColors.cprButtonPink,
          onPressed: () {
            CPRRoutes.createReview(context, place: place,usePromotion:usePromotion);
          },
          child: Text(
            "Create Review",
            style: CPRTextStyles.buttonMediumWhite,
          ),
        ),
      ),
    );
  }
}
