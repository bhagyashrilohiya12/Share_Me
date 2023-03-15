import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/constants/cpr_urls.dart';
import 'package:cpr_user/helpers/location_helper.dart';
import 'package:cpr_user/helpers/places_helper.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart' as p;

class ClickPicReviewButton extends StatelessWidget {
  // const ClickPicReviewButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return p.Consumer<PlacesProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () async {
            // var placeResult = await PlacesAutocomplete.show(
            //     context: context,
            //     apiKey: PlacesAPI.googlePlacesKey,
            //     mode: Mode.fullscreen,
            //     language: "en");
            // if (placeResult != null) {
            //   provider.findPlace(placeResult.placeId).then((place) async {
            //     Map<String, dynamic> values = {};
            //     if (place.location == null) {
            //       try {
            //         // var location =
            //         //     LocationHelper.convertGeopointToGeoFireLocation(
            //         //             place.coordinate)
            //         //         .data;
            //         // values.putIfAbsent("location", () => location);
            //       } catch (e) {
            //         print(e);
            //       }
            //     }
            //     if (place.googlePhotoReferences == null ||
            //         place.googlePhotoReferences.isEmpty ||
            //         true) {
            //       try {
            //         var placeDetails =
            //             await PlacesHelper.findPlaceDetailsByPlaceID(
            //                 placeResult.placeId);
            //         var results = placeDetails["result"];
            //         var photos = results["photos"] as List;
            //         var gPhotosRef = photos
            //             .map((photo) => photo["photo_reference"].toString())
            //             .toList();
            //         values.putIfAbsent(
            //             "googlePhotoReferences", () => gPhotosRef);
            //       } catch (e) {
            //         print(e);
            //       }
            //     }
            //     try {
            //       place = await provider.updatePlaceDetail(
            //           place.documentId, values);
            //     } catch (e) {
            //       print(e);
            //     }
            //
            //     Navigator.of(context).push(CPRRoutes.placesDetailPage(place));
            //   }).catchError((onError) async {
            //     try {
            //       var placeDetails =
            //           await PlacesHelper.findPlaceDetailsByPlaceID(
            //               placeResult.placeId);
            //
            //       var place =
            //           Place.fromGooglePlacesResult(placeDetails["result"]);
            //
            //       CPRRoutes.createReview(context, place: place);
            //     } catch (e, s) {
            //       print(s);
            //       print(e);
            //     }
            //   });
            // }
          },
          child: Material(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 36,
                    padding: EdgeInsets.fromLTRB(8,2,8,2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.black87,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/images/click_pic_and_review_text.png'),
                            fit: BoxFit.fitHeight,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
