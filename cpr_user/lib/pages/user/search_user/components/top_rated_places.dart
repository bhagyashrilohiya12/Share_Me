import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/models/near_rate_places.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/pages/user/home_page/components/categorized_places_list.dart';
import 'package:cpr_user/pages/user/search_user/components/top_rated_places_full_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../models/get_top_rate_near_palce.dart';

class TopRatedPlaces extends StatelessWidget {

  //!.nearRatePlaces!
  TopRatedPlaces(this.categoryName, this.topRateNearPalce, this.currentLocation) {

    if( topRateNearPalce != null ) {
      nearRatePlaces = topRateNearPalce!.nearRatePlaces;
    }
  }

  String categoryName;
  GetTopRateNearPalce? topRateNearPalce;
  List<NearRatePlaces>?  nearRatePlaces ;
  GeoPoint currentLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      //color: Colors.cyan,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.favorite,color: Colors.red,),
              SizedBox(width: 8,),
              Text(
                categoryName,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              Expanded(child: Text("")),
              if (nearRatePlaces != null && nearRatePlaces!.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (bottomSheetContext) {
                          return Container(
                            child: TopRatedPlacesFullList(currentLocation),
                            height: MediaQuery.of(context).size.height * .85,
                          );
                        });
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: nearRatePlaces == null
                ? SpinKitThreeBounce(
                    color: Theme.of(context).accentColor,
                    size: 24,
                  )
                : nearRatePlaces!.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          Place place = nearRatePlaces![i].place!;
                          return PlaceMiniCard(
                            place: place,
                            isReview: false,
                            categoryName: categoryName,
                            userLocation: currentLocation,
                            showReviewImage: false,
                          );
                        },
                        itemCount: nearRatePlaces!.length,
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "No results found",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
          )
        ],
      ),
    );
  }
}
