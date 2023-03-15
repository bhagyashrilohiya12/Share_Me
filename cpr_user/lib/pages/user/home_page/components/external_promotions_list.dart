import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/models/business_external_promotion.dart';
import 'package:cpr_user/pages/common/components/cpr_search.dart';
import 'package:cpr_user/pages/common/components/cpr_search_external_promotions.dart';
import 'package:cpr_user/pages/user/external_promotion_page/external_promotion_detail_page.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:provider/provider.dart' as p;
import 'package:ribbon/ribbon.dart';

class ExternalPromotionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sessionProvider = p.Provider.of<SessionProvider>(context);
    return Container(
      height: 170,
      padding: const EdgeInsets.only(left: 16, right: 16),
      margin: const EdgeInsets.only(top:30),
      //color: Colors.cyan,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Promotions",
                style: CPRTextStyles.smallHeaderBoldDarkBackground,
              ),
              GestureDetector(
                onTap: () async {
                  sessionProvider.startLoading();
                  List<CPRBusinessExternalPromotion> externalPromotions = await sessionProvider.getExternalAllPromotions();
                  var searchComponent = CPRSearchExternalPromotions(
                        externalPromotions: externalPromotions,
                      );
                  sessionProvider.stopLoading();
                  showModalBottomSheet(
                      context: context,
                      builder: (bottomSheetContext) {
                        return Container(
                          child: searchComponent,
                          height: MediaQuery.of(context).size.height * 0.7,
                        );
                      });
                  // Scaffold.of(context).showBottomSheet();
                },
                child: sessionProvider.externalPromotions == null || sessionProvider.externalPromotions!.isEmpty
                    ? SizedBox()
                    : Text(
                        "See all",
                        style: CPRTextStyles.smallHeaderNormalDarkBackground,
                      ),
              ),
            ],
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                List<Widget> children;
                if (sessionProvider.externalPromotions != null && sessionProvider.externalPromotions!.isNotEmpty) {
                  children = sessionProvider.externalPromotions!.map((f) => PromotionMiniCard(
                            externalPromotion: f,
                            userLocation: sessionProvider.currentLocation!,
                          ))
                      .toList();
                } else {
                  children = [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  ];
                }
                return ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(top: 10), children: children);
              },
            ),
          )
        ],
      ),
    );
  }
}

class PromotionMiniCard extends StatelessWidget {
   CPRBusinessExternalPromotion externalPromotion;
   GeoPoint userLocation;

   PromotionMiniCard({
    required this.externalPromotion,
     required this.userLocation,

  })  ;

  @override
  Widget build(BuildContext context) {
    var placesProvider = p.Provider.of<PlacesProvider>(context);
    var homeProvider = p.Provider.of<SessionProvider>(context, listen: false);

    return GestureDetector(
      onTap: () async {
        homeProvider.startLoading();
        try {
          var updatedPlace = await placesProvider.findPlace(externalPromotion.placeId!);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExternalPromotionDetailPage(externalPromotion: externalPromotion ,place: updatedPlace!)));
          homeProvider.stopLoading();
        } catch (e) {
          print(e);
          homeProvider.stopLoading();
        }
      },
      child: Container(
        // color: color,
        margin: EdgeInsets.only(right: CPRDimensions.homeMarginBetweenCard, bottom: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
        width: 180,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Ribbon(
            nearLength: 44,
            farLength: 68,
            title: externalPromotion.title,
            titleStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold),
            color: Color(0xffa22664),
            location: RibbonLocation.topStart,
            child:  Container(
              height: 90,
              width: 180,
              child: externalPromotion.pictureURL!=null?ExtendedImage.network(
                externalPromotion.pictureURL!,
                fit: BoxFit.cover,
                cache: true,
              ):SizedBox(),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
