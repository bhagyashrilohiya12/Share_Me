import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/constants/cpr_urls.dart';
import 'package:cpr_user/helpers/string_helper.dart' as stringHelper;
import 'package:cpr_user/models/promotion_win_reviews.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;

class ReviewWinnerItem extends StatefulWidget {
  final Review review;
  final PromotionWinReviews promotionWinReview;
  GeoPoint? userLocation;

   ReviewWinnerItem({

    this.userLocation,
    required this.review,
    required this.promotionWinReview,
  }) ;

  @override
  _ReviewWinnerItemState createState() => _ReviewWinnerItemState();
}

class _ReviewWinnerItemState extends State<ReviewWinnerItem> {
  CPRUser? user;

  @override
  void initState() {
    if (widget.review.userID != null) getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var homeProvider = p.Provider.of<SessionProvider>(context, listen: false);
    var pic = "";
    if (widget.review.downloadURLs != null && widget.review.downloadURLs!.isNotEmpty) {
      pic = widget.review.downloadURLs![0];
    } else {
      pic =
          "${PlacesAPI.googlePhotoReferenceUrl}?key=${PlacesAPI.googlePlacesKey}&photoreference=${widget.review.place?.firstGooglePhotoReference}&maxwidth=${130}";
    }
    return GestureDetector(
      onTap: () async {
        homeProvider.startLoading();
        var updatedPlace = await PlacesService().findPlaceById(widget.review.placeID!);
        Navigator.of(context)
            .push(CPRRoutes.reviewDetailPage(widget.review, updatedPlace!, userLocation: widget.userLocation));
        homeProvider.stopLoading();
      },
      child: Container(
        height: 140,
        width: 200,
        margin: EdgeInsets.only(right: CPRDimensions.homeMarginBetweenCard),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 24),
              child: Column(children: <Widget>[
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 100,
                        width: 200,
                        child: ExtendedImage.network(
                          pic,
                          fit: BoxFit.cover,
                          cache: true,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                    Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                            child: Text(widget.promotionWinReview.reward!,
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      stringHelper.formatMaxString(widget.review.place!.name!, 10),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      stringHelper.formatMaxString(widget.review.place!.address!, 20),
                      style: CPRTextStyles.cardSubtitle.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  getUser() async {
    UserService userService = new UserService();
    CPRUser? userTemp = await userService.getUserById(widget.review.userID!);
    setState(() {
      user = userTemp;
    });
  }
}
