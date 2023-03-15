import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/analytics_types.dart';
import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/constants/cpr_urls.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/interfaces/searchable.dart';
import 'package:cpr_user/models/analytics.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/analytics_service.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart' as p;

class ResultListTile<T extends Searchable> extends StatelessWidget {
  final T result;
  final isDraftReview;

  const ResultListTile({required this.result, this.isDraftReview = false })  ;

  @override
  Widget build(BuildContext context) {
    String photoRef = "";
    try {
      if (result is Review) {
        Log.i( "ResultListTile - result is Review");
        if ((result as Review).downloadURLs != null && (result as Review).downloadURLs!.isNotEmpty) {
          photoRef = (result as Review).downloadURLs![0];
        } else {
          photoRef =
              "${PlacesAPI.googlePhotoReferenceUrl}?key=${PlacesAPI.googlePlacesKey}&photoreference=${(result as Review).place?.firstGooglePhotoReference}&maxwidth=${130}";
        }
      } else {
        photoRef = OtherHelper.findPhotoReference(size: 1024, photoRef: (result as Place).googlePhotoReferences!.first);
      }
    } catch (e) {
      print(e);
    }
    return GestureDetector(
      onTap: () async {

        if (result is Review) {
          if (isDraftReview!=null && isDraftReview) {
            CPRRoutes.createReview(context, place: (result as Review).place, usePromotion: (result as Review).promotionDocId != null);
          } else {

            Place? place;
            try {
              String? placeID =  (result as Review).placeID;
              place = await PlacesService().findPlaceById(  placeID!  );

            } catch (e) {}

            if( place == null ) {
              return ;
            }

            Navigator.of(context).push(CPRRoutes.reviewDetailPage(result as Review, place));
          }
        } else if (result is Place) {
          Navigator.of(context).push(CPRRoutes.placesDetailPage(result as Place));
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
                        result.firstTile,
                        style: CPRTextStyles.cardTitleBlack,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        result.secondTile,
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
    if( result  == null ) return EmptyView.zero();
    if( result.iconTile == null ) return EmptyView.zero();

    return RatingBarIndicator(
      rating: double.parse(result.iconTile),
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


}
