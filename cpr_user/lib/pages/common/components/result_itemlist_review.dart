import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/constants/cpr_urls.dart';
import 'package:cpr_user/interfaces/searchable.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/result_list_tile.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';

import 'package:cpr_user/models/place.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ResultItemListReview   extends StatelessWidget {

  Review review;
  bool? isDraftReview  ;

  ResultItemListReview( this.review);

  String photoRef = "";

  @override
  Widget build(BuildContext context) {

    setPhotoRefUrl();

    return GestureDetector(
      onTap: () async {


          if (isDraftReview!=null && isDraftReview!) {
            CPRRoutes.createReview(context, place: review.place, usePromotion: review.promotionDocId != null);
          } else {

            Place? place;
            try {
              String? placeID =  review.placeID;
              place = await PlacesService().findPlaceById(  placeID!  );

            } catch (e) {}

            if( place == null ) {
              return ;
            }

            Navigator.of(context).push(CPRRoutes.reviewDetailPage(review, place));
          }

      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 70,
              height: 70,
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: getPhoto(photoRef) ,
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.rectangle,
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        review.firstTile,
                        style: CPRTextStyles.cardTitleBlack,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        review.secondTile,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CPRTextStyles.cardSubtitleBlack,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    getRatingBarIndecator()
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getPhoto(String? photoRef) {
    /**
     * #abdo
        photoRef != null
        ? ExtendedNetworkImageProvider(photoRef, cache: true)
        : AssetImage("assets/images/bg_image_not_available_squre.jpg")
     */
    if( ToolsValidation.isEmpty( photoRef) ) {
      return AssetImage("assets/images/bg_image_not_available_squre.jpg");
    } else {
      return  ExtendedNetworkImageProvider(photoRef!, cache: true);
    }
  }

  getRatingBarIndecator() {

    // bool isNotReviewType = result is Review == false;
    // if(  isNotReviewType) {
    //   return EmptyView.zero();
    // }

   // Log.i( "getRatingBarIndecator() - rating " +  review.rating.toString() );
   // Log.i( "getRatingBarIndecator() - review " +  review.toString() );

    // if( ToolsValidation.isEmpty( review.iconTile) ) return EmptyView.zero();

    return RatingBarIndicator(
      rating: review.rating??0 ,
      // rating: double.parse(review.iconTile),
      unratedColor: Colors.grey,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 24.0,
      direction: Axis.horizontal,
    );
  }

  void setPhotoRefUrl() {

    try {

      if( review.downloadURLs != null && review.downloadURLs!.isNotEmpty ) {
        photoRef = review.downloadURLs![0];
        return;
      }

      photoRef = "${PlacesAPI.googlePhotoReferenceUrl}?key=${PlacesAPI.googlePlacesKey}&photoreference=${review.place?.firstGooglePhotoReference}&maxwidth=${130}";

    } catch (e) {
      print(e);
    }
  }


}
