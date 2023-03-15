import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/constants/network_error_codes.dart';
import 'package:cpr_user/models/get_top_rate_near_palce.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/pages/common/components/cpr_header.dart';
import 'package:cpr_user/pages/common/components/cpr_separator.dart';
import 'package:cpr_user/pages/common/components/result_list_tile.dart';
import 'package:cpr_user/services/network_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class TopRatedPlacesFullList extends StatefulWidget {
  var currentLocation;

  TopRatedPlacesFullList(this.currentLocation);

  @override
  _TopRatedPlacesFullListState createState() => _TopRatedPlacesFullListState();
}

class _TopRatedPlacesFullListState extends State<TopRatedPlacesFullList> {
  GetTopRateNearPalce? topRateNearPalce;
  String selectedRateRange = 'All';

  @override
  void initState() {
    getTopRateNearPlace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 0),
            padding: const EdgeInsets.all(8.0),
            child: CPRHeader(
              height: 64,
              title: Text(
                "Top near places",
                style: CPRTextStyles.cardTitle.copyWith(fontSize: 12),
              ),
              subtitle: Text("Top near places around you", style: CPRTextStyles.cardSubtitle.copyWith(fontSize: 10)),
              icon: MaterialCommunityIcons.compass,
            ),
          ),
          CPRSeparator(),
          Container(
              height: 56,
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16,0,16,0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(flex: 4, child: Text("Select Category",style: TextStyle(
                      fontWeight: FontWeight.w600
                    ),)),
                    Expanded(
                      flex: 3,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            hint: Text("Category"),
                            isExpanded: true,
                            items: <String>[
                              'All',
                              'Bars and Taverns',
                              'Restaurants',
                              'Salons and Spas',
                              'Coffee Shops',
                              'Hotels',
                              'Wellbeing'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: selectedRateRange,
                            onChanged: (v) {
                              FocusScope.of(context).unfocus();
                              selectedRateRange = v??"";
                              getTopRateNearPlace();
                            },
                            underline: SizedBox(),
                          )),
                    )
                  ],
                ),
              )),
          CPRSeparator(),
          Expanded(
            child: topRateNearPalce == null
                ? SpinKitThreeBounce(
                    color: Theme.of(context).accentColor,
                    size: 24,
                  )
                : topRateNearPalce!.nearRatePlaces != null && topRateNearPalce!.nearRatePlaces!.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, i) {
                          Place place = topRateNearPalce!.nearRatePlaces![i].place!;
                          return ResultListTile(
                            isDraftReview: false,
                            result: place,
                          );
                        },
                        itemCount: topRateNearPalce!.nearRatePlaces!.length,
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "No results found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
          )
        ],
      ),
    );
  }

  Future<void> getTopRateNearPlace() async {
    setState(() {
      topRateNearPalce = null;
    });
    var res = await networkService.callApi(
        url: BASE_URL +
            "app/getTopRateNearPlace?lat=${widget.currentLocation.latitude}&lng=${widget.currentLocation.latitude}&top=100&category=${MainCategoryUtil.getCategoryFromDisplayName(selectedRateRange)}",
        requestMethod: RequestMethod.GET);

    if (res == NetworkErrorCodes.RECEIVE_TIMEOUT ||
        res == NetworkErrorCodes.CONNECT_TIMEOUT ||
        res == NetworkErrorCodes.SEND_TIMEOUT) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Time Out Error !"),
      ));
    } else if (res == NetworkErrorCodes.SOCKET_EXCEPTION) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No Internet Connection !"),
      ));
    } else {
      GetTopRateNearPalce topRateNearPalceTemp = GetTopRateNearPalce.fromJson(res);
      setState(() {
        topRateNearPalce = topRateNearPalceTemp;
      });
    }
  }
}
