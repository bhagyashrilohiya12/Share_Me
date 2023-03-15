import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/analytics_types.dart';
import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/helpers/launcher_helper.dart';
import 'package:cpr_user/helpers/location_helper.dart';
import 'package:cpr_user/main.dart';
import 'package:cpr_user/models/analytics.dart';
import 'package:cpr_user/models/events/review_delete.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/common/components/review_card.dart';
import 'package:cpr_user/pages/user/places_details_page/components/business_avatar.dart';
import 'package:cpr_user/pages/user/places_details_page/components/cpr_place_buttons.dart';
import 'package:cpr_user/pages/user/places_details_page/components/cpr_rating.dart';
import 'package:cpr_user/pages/user/places_details_page/components/place_photos.dart';
import 'package:cpr_user/pages/user/review_details_page/components/simple_review_card.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/resource/toast/ToolsToast.dart';
import 'package:cpr_user/services/analytics_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart' as p;

class PlacesDetailPage extends StatefulWidget {
  Place place;
  String? categoryName;
  Review? review;

  PlacesDetailPage({  required this.place, this.categoryName, this.review}) ;

  @override
  _PlacesDetailPageState createState() => _PlacesDetailPageState();
}

class _PlacesDetailPageState extends State<PlacesDetailPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool analyticsAdded = false;
  StreamSubscription? subscription ;

  @override
  void initState() {
    print(widget.place.documentId);
    super.initState();
    Log.i("PlacesDetailPageState - initState() - place: " +
        widget.place.toString());
  }



  @override
  Widget build(BuildContext context) {
    Log.i("page  - PlacesDetailPageState - build");

    double width = MediaQuery.of(context).size.width * 0.45;
    //Reference not listing to refresh
    var sessionProvider = p.Provider.of<SessionProvider>(context, listen: false);
    if(analyticsAdded==false){
      addAnalytics(AnalyticsTypes.HOW_MANY_PEOPLE_SEARCH_AND_CLICK_ON_A_BUSINESS_PROFILE.index,
          sessionProvider.user!.email! );
      setState(() {
        analyticsAdded = true;
      });
    }

    subscription = eventBus.on<ReviewDelete>().listen((event) {
      print("event.index");
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    });

    return CPRContainer(
        loadingWidget: Builder(
          builder: (context) {
            var loadingProvider = p.Provider.of<SessionProvider>(context);
            return CPRLoading(
              loading: loadingProvider.busy,
            );
          },
        ),
        child: Scaffold(
          backgroundColor: Colors.black,
          key: scaffoldKey,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          BusinessAvatar(widget.place),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Text(
                                    widget.place.name ?? "",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                CPRRating(getPlaceValid()),
                              ],
                            ),
                          ),
                        ],
                      ),
                      p.Consumer<SessionProvider>(
                        builder: (context, userProvider, _) {
                          if (widget.place.documentId == null) {
                            return Container();
                          }
                          bool isInSaveForLater = userProvider.isInCategory(
                              widget.place, MainCategory.saveForLaterPlaces);
                          bool inInFavorites = userProvider.isInCategory(
                              widget.place, MainCategory.myFavoritePlaces);

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: width,
                                  child: GestureDetector(
                                    onTap: () async {
                                      sessionProvider.startLoading();
                                      try {
                                        if (!inInFavorites) {
                                          await userProvider.addToCategory(
                                              widget.place,
                                              MainCategory.myFavoritePlaces);
                                        } else {
                                          await userProvider.removeFromCategory(
                                              widget.place,
                                              MainCategory.myFavoritePlaces);
                                        }
                                      } catch (e) {}

                                      sessionProvider.stopLoading();
                                    },
                                    child: Material(
                                      color: CPRColors.cprButtonGreen,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        child: Center(
                                          child: Text(
                                            "${inInFavorites ? 'Remove from Favorites' : 'Add to Favorites'}",
                                            style:
                                                CPRTextStyles.buttonSmallWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width,
                                  child: GestureDetector(
                                    onTap: () async {
                                      sessionProvider.startLoading();
                                      try {
                                        if (!isInSaveForLater) {
                                          await userProvider.addToCategory(
                                              widget.place,
                                              MainCategory.saveForLaterPlaces);
                                        } else {
                                          await userProvider.removeFromCategory(
                                              widget.place,
                                              MainCategory.saveForLaterPlaces);
                                        }
                                      } catch (e) {}

                                      sessionProvider.stopLoading();
                                    },
                                    child: Material(
                                      color: CPRColors.cprButtonPink,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        child: Center(
                                          child: Text(
                                            "${isInSaveForLater ? 'Remove from Save For Later' : 'Add to Save For Later'}",
                                            style: CPRTextStyles
                                                .buttonSmallWhite
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      if (this.widget.review != null)
                        SimpleReviewCard(
                          review: widget.review!,
                          showMore: true,
                          loginedUser: sessionProvider.user!,
                        ),
                      CPRPlaceButtons(this.widget.place, (analyticsType) {
                        addAnalytics(
                            analyticsType, sessionProvider.user!.email!);
                      }),
                      PlacePhotos(this.widget.place),
                      // HistoryCard(
                      //   place: widget.place,
                      // ),

                      getReviewCard(sessionProvider),

                      Container(
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: ExtendedImage.network(
                                    LocationHelper.buildStaticMapUrl(
                                        widget.place.coordinate!,
                                        zoom: 4),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.place.address ?? "",
                                        style: TextStyle(
                                            color: widget.place.address != null ? Colors.black : Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        addAnalytics(
                                            AnalyticsTypes.HOW_MANY_PEOPLE_LOOK_FOR_DIRECTIONS_FROM_CPR.index,
                                            sessionProvider.user!.email!);
                                        MapsLauncher.launchCoordinates(widget.place.coordinate!.latitude, widget.place.coordinate!.longitude);
                                      },
                                      child: Text(
                                        "Directions",
                                        style: TextStyle(color: Get.theme.accentColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                width: Get.width,
                                height: 1,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.place.phone ?? "",
                                        style: TextStyle(
                                            color: widget.place.phone != null ? Colors.black : Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    if (widget.place.coordinate != null)
                                      GestureDetector(
                                        onTap: () {

                                          if( ToolsValidation.isEmpty(widget.place.phone ) ) {
                                            ToolsToast.i( context, "No Phone Number Found!");
                                            return;
                                          }

                                          addAnalytics(
                                              AnalyticsTypes.HOW_MANY_PEOPLE_CALL_THE_BUSINESS_FROM_CPR.index, sessionProvider.user!.email!);
                                          LauncherHelper.launchURL("tel:" + widget.place.phone!);
                                        },
                                        child: Text(
                                          "Call Now",
                                          style: TextStyle(color: Get.theme.accentColor),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                width: Get.width,
                                height: 1,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.place.website ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: widget.place.website != null ? Colors.black : Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    if (widget.place.coordinate != null)
                                      GestureDetector(
                                        onTap: () {
                                          if( ToolsValidation.isEmpty(widget.place.website ) ) {
                                            ToolsToast.i( context, "No Website Found!");
                                            return;
                                          }


                                          addAnalytics(AnalyticsTypes.HOW_MANY_PEOPLE_CLICK_ON_THE_BUSINESSES_WEBSITE_FROM_CPR.index,
                                              sessionProvider.user!.email!);
                                          LauncherHelper.launchURL(widget.place.website!);
                                        },
                                        child: Text(
                                          "View",
                                          style: TextStyle(color: Get.theme.accentColor),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBackButton()
          ],
        ),
      )
    );
  }

  Positioned _buildBackButton() {
    return Positioned(
      top: 50,
      left: 20,
      child: Row(
        children: <Widget>[
          Material(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
                height: 40,
                width: 40,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void addAnalytics(int analyticsType, visitorId) async {
    AnalyticsService analyticsService = new AnalyticsService();
    Analytics? a = await analyticsService.addAnalytic(new Analytics(
        analyticsType: analyticsType,
        placeId: widget.place.googlePlaceID,
        visitorId: visitorId,
        visitTime: Timestamp.fromDate(DateTime.now()), documentID: ''));
  }

  Place getPlaceValid() {
    /*
    * #abdo
    widget.place ?? widget.review.place!
     */

    if( widget.place == null ) {
      return widget.review!.place!;
    }
    return widget.place;
  }

  Widget getReviewCard(SessionProvider sessionProvider) {
    /**
     * #abdo
        if (widget.place.googlePlaceID != null)
        ReviewCard(place: widget.place, excludeReview: widget.review!.documentId!,
        loginedUser: sessionProvider.user!),
     */
    if (widget.place.googlePlaceID == null) {
      return EmptyView.zero();
    }
    if( widget.review == null ) {
      return EmptyView.zero();
    }

    //show
    return   ReviewCard(place: widget.place,
        excludeReview: widget.review!.documentId??"",
        loginedUser: sessionProvider.user!);
  }

  download() {
    return Builder(
      builder: (context) {

        return CPRLoading(
          loading: true,
        );
      },
    );
  }



}
