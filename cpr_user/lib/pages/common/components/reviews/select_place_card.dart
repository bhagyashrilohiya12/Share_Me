import 'package:cpr_user/helpers/places_helper.dart';
import 'package:cpr_user/models/business_internal_promotion.dart';
import 'package:cpr_user/models/business_server.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/pages/common/components/cpr_card.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/providers/review_manager_provider.dart';
import 'package:cpr_user/services/business_internal_promotions_service.dart';
import 'package:cpr_user/services/server_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart' as p;

import '../../../user/search_and_get_place/serach_and_get_place.dart';

class SelectPlaceCard extends StatelessWidget {
  final ReviewManagerProvider provider;

  SelectPlaceCard({  required this.provider}) ;

  @override
  Widget build(BuildContext context) {
    var placeProvider = p.Provider.of<PlacesProvider>(context, listen: false);


    Log.i( "SelectPlaceCard - build() - provider.place: "  + provider.place.toString() );

    return CPRCard(
      // height: 140,
      title: Text(
        "Where did you go?",
        style: CPRTextStyles.cardTitleBlack,
      ),
      subtitle: Text(
        "The place that you want to review",
        style: CPRTextStyles.cardSubtitleBlack,
      ),
      backgroundColor: Colors.white,
      icon: MaterialCommunityIcons.map_search,
      child:  _getCardContent( context, provider, placeProvider),
    );
  }

  Widget buttonAddPlace(ReviewManagerProvider provider, BuildContext context, PlacesProvider placeProvider) {
    Log.i("buttonAddPlace() show ");

    return ButtonTemplate.t(  "Select a place", () async {
      await _clickPickerPlace(context, placeProvider);
    },
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      // levelDS: LevelDS.l3,
        textDimen: 14,
        // height: 50,
        // decoration: BoarderHelper.cardView( radiusSize: 16),
      background: CPRColors.pink_hex
    );

//     return GestureDetector(
//       onTap: () async {
//         await _clickPickerPlace(context, placeProvider);
//       },
//       child: Container(
//           padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//                height: 50,
// //                 width: MediaQuery.of(context).size.width * 0.9,
//           decoration: BoxDecoration(
//               color: CPRColors.cprButtonPink, borderRadius: BorderRadius.all(Radius.circular(10))),
//           child: Text(
//             "Select a place",
//             style: CPRTextStyles.buttonMediumWhite,
//           )),
//     );
  }


  _clickPickerPlace(BuildContext context, PlacesProvider placeProvider ) async {
    var placeResult = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SerachAndGetPlacePage()));
    provider.startLoading();
    if (placeResult != null) {
      placeProvider.findPlace(placeResult.placeId).then(
            (place) async {
          provider.promotions = [];
          provider.employees = [];
          provider.selectedEmployee = null;
          if (place != null) {
            provider.place = place;
            if (place.businessOwnerEmail != null) {
              provider.employees = await ServerService().findEmployees(place.businessOwnerEmail!);
              provider.employees!.add(CPRBusinessServer());
              // List<CPRBusinessExternalPromotion> externalPromotions = await BusinessExternalPromotionsService().getExternalPromotionsOfPlace(place.googlePlaceID);
              List<CPRBusinessInternalPromotion> internalPromotions =
              await BusinessInternalPromotionsService()
                  .getInternalPromotionsOfPlace(place.googlePlaceID!);
              provider.promotions = [];

              if (internalPromotions != null && internalPromotions.isNotEmpty) {
                try {
                  List<CPRBusinessInternalPromotion> internalPromotionsTemp = internalPromotions
                      .where((element) => (DateTime.now().difference(element.startDate!) > Duration() &&
                      DateTime.now().difference(element.endDate!) < Duration()))
                      .toList();
                  provider.promotions.addAll(internalPromotionsTemp);
                  // provider.promotions.addAll(externalPromotions);
                } catch (e) {
                  print(e);
                }
              }
            }
            provider.notifyListeners();
          } else {
            var detail = await PlacesHelper.findPlaceDetailsByPlaceID(placeResult.placeId);
            var place = Place.fromGooglePlacesResult(detail["result"]);
            provider.place = place;
          }
          provider.stopLoading();
          //Navigator.of(context).push(CPRRoutes.placesDetailPage(place));
        },
      );
    }else{
      provider.stopLoading();
    }
  }

  _getCardContent(BuildContext context, ReviewManagerProvider provider, PlacesProvider placeProvider  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
//        color:Colors.green,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: provider.place == null
            ?  buttonAddPlace( provider, context, placeProvider)
            : Stack(

          /**
           * #abdo
              // overflow: Overflow.visible,
           */

          clipBehavior: Clip.none,

          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//                height: 50,
//                 width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: CPRColors.cprButtonPink, borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text(
                "${provider.place?.name}",
                style: CPRTextStyles.buttonMediumWhite,
              ),
            ),
            Positioned(
              top: -10,
              right: -10,
              child: GestureDetector(
                onTap: () async {
                  var placeResult = await Navigator.push(
                      context, new MaterialPageRoute(builder: (context) => SerachAndGetPlacePage()));

                  if (placeResult != null) {
                    placeProvider.findPlace(placeResult.placeId).then(
                          (place) async {
                        if (place != null) {
                          provider.place = place;
                          if (place.businessOwnerEmail != null){
                            provider.employees = await ServerService().findEmployees(place.businessOwnerEmail!);
                            provider.employees!.add(new CPRBusinessServer());
                          }
                          provider.notifyListeners();
                        } else {
                          var detail = await PlacesHelper.findPlaceDetailsByPlaceID(placeResult.placeId);
                          provider.place = Place.fromGooglePlacesResult(detail["result"]);
                        }
                        //Navigator.of(context).push(CPRRoutes.placesDetailPage(place));
                      },
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black.withOpacity(0.2))),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      MaterialCommunityIcons.square_edit_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
