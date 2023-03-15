import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/sort_types.dart';
import 'package:cpr_user/interfaces/searchable.dart';
import 'package:cpr_user/pages/common/components/cpr_header.dart';
import 'package:cpr_user/pages/common/components/cpr_separator.dart';
import 'package:cpr_user/pages/common/components/result_list_place.dart';
import 'package:cpr_user/pages/common/components/result_list_review.dart';
import 'package:cpr_user/providers/search_provider.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart' as p;

import 'result_list_generic.dart';

class CPRSearch <T extends Searchable> extends StatelessWidget {

// final Place place;
  final List<T> reviews;
  final String? title;
  final String? subtitle;
  GeoPoint? currentLocation;
  double? topMargin;
  bool isDraftReview = false ;


  String searchKey = "";
  String? sortType ;
  double startRateRange = 1.0;
  double endRateRange = 5.0;
  double distance = 100;
  bool enableDistanceFilter = false;

// final CPRSearchType cprSearchType;
  CPRSearch(
      {
      this.title = "Title",
      this.subtitle = "Subtitle",
      required this.reviews,
       this.currentLocation,
        double? this.topMargin,
      this.isDraftReview = false}) ;


  @override
  Widget build(BuildContext context) {
    Log.i( "page - CPRSearch() - build - dialog");


    return p.ChangeNotifierProvider.value(
      value: SearchProvider<T>(reviewsOrPlaces: reviews),
      child: p.Consumer<SearchProvider<T>>(
        builder: (context, provider, _) {
          return Material(
            elevation: 16,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            color: Colors.black,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: topMargin ?? 0),
                  padding: const EdgeInsets.all(8.0),
                  child: CPRHeader(
                    height: 64,
                    title: Text(
                      title!,
                      style: CPRTextStyles.cardTitle.copyWith(fontSize: 14),
                    ),
                    subtitle: Text(
                      subtitle!,
                      style: CPRTextStyles.cardSubtitle.copyWith(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    icon: MaterialCommunityIcons.compass,
                  ),
                ),
                CPRSeparator(),
                Container(
                  height: 188,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Search in Hashtags",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text(
                                  "Filter Rate",
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: TextField(
                                  decoration: CPRInputDecorations.cprFilter,
                                  onChanged: (value) {
                                    searchKey = value;

                                    provider.filter(value, startRateRange, endRateRange, currentLocation!,
                                        getDistanceFiltered() );
                                  },
                                ),
                              ),
                            ),
                            flex: 3,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownButton<String>(
                                  hint: Text(
                                    "Sorting",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  isExpanded: true,
                                  items: <String>['Rating-Ascending','Rating-Descending'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  value: sortType,
                                  onChanged: (v) {
                                    FocusScope.of(context).unfocus();
                                    sortType = v;
                                    if (v == 'Rating-Ascending') {
                                      provider.sort(SortType.ratingAscending);
                                    } else if (v=='Rating-Descending'){
                                      provider.sort(SortType.ratingDescending);
                                    }
                                  },
                                  underline: SizedBox(),
                                )),
                            flex: 2,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: Colors.white,
                              ),
                              child:Checkbox(
                              value: enableDistanceFilter,
                              onChanged: (v) {
                                enableDistanceFilter = v ?? false ;
                                provider.filter(searchKey, startRateRange, endRateRange, currentLocation!,
                                    enableDistanceFilter ? distance * 1000 : null);
                              })),
                          Text(
                            "Distance : ",
                            style: TextStyle(color: Colors.white),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Theme.of(context).accentColor,
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0),
                                overlayShape: RoundSliderOverlayShape(overlayRadius: 10.0),
                              ),
                              child: Slider(
                                value: distance,
                                onChanged: (v) {
                                  distance = v;
                                  provider.filter(searchKey, startRateRange, endRateRange, currentLocation!,
                                      getDistanceFiltered());
                                },
                                max: 100,
                                min: 1,
                              ),
                            ),
                          )
                        ],
                      ),
                      if (enableDistanceFilter)
                        Row(
                          children: [
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              distance.toStringAsFixed(2) + " Kilometers",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Showing ${provider.filteredReviewsOrPlaces!.length} results",
                          style: CPRTextStyles.cardSubtitle,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ResultListGeneric(
                      list: provider.filteredReviewsOrPlaces!,
                      isDraftReview: isDraftReview,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double? getDistanceFiltered() {
    /**
     * - #abdo
        //enableDistanceFilter! ? distance * 1000 : null
     */

    if( enableDistanceFilter ) {
      return distance * 1000;
    } else {
      return null ;
    }
  }


}
