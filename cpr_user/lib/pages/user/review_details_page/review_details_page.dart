import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/analytics_types.dart';
import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/helpers/launcher_helper.dart';
import 'package:cpr_user/helpers/location_helper.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/helpers/social_post_helper.dart';
import 'package:cpr_user/main.dart';
import 'package:cpr_user/models/analytics.dart';
import 'package:cpr_user/models/events/review_changes.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/cpr_back_button.dart';
import 'package:cpr_user/pages/common/components/cpr_button.dart';
import 'package:cpr_user/pages/common/components/cpr_confirm_dialog.dart';
import 'package:cpr_user/pages/common/components/cpr_container.dart';
import 'package:cpr_user/pages/common/components/cpr_like_review_button.dart';
import 'package:cpr_user/pages/common/components/cpr_loading.dart';
import 'package:cpr_user/pages/user/places_details_page/components/cpr_rating.dart';
import 'package:cpr_user/pages/user/places_details_page/components/cpr_working_hours.dart';
import 'package:cpr_user/pages/user/review_details_page/components/rating_waiting_badges.dart';
import 'package:cpr_user/pages/user/review_details_page/components/review_sharing_options.dart';
import 'package:cpr_user/pages/user/review_details_page/components/simple_review_card.dart';
import 'package:cpr_user/providers/review_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/resource/toast/ToolsToast.dart';
import 'package:cpr_user/services/analytics_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart' as p;

class ReviewDetailsPage extends StatefulWidget {
  Review review;
  final Place place;

  // final String categoryName;
  // final GeoPoint userLocation;

  ReviewDetailsPage({required this.review, required this.place});

  @override
  State<ReviewDetailsPage> createState() => _ReviewDetailsPageState();
}

class _ReviewDetailsPageState extends State<ReviewDetailsPage> {
  bool analyticsAdded = false;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    Log.i(
        "ReviewDetailsPage - initState() - place: " + widget.place.toString());
  }

  @override
  Widget build(BuildContext context) {
    Log.i("page - ReviewDetailsPage - build");

    double width = MediaQuery.of(context).size.width * 0.45;
    var sessionProvider =
        p.Provider.of<SessionProvider>(context, listen: false);
    if (analyticsAdded == false) {
      addAnalytics(AnalyticsTypes.HOW_MANY_PEOPLE_HAVE_READ_A_REVIEW.index,
          sessionProvider.user!.email);
      setState(() {
        analyticsAdded = true;
      });
    }

    subscription = eventBus.on<ReviewChanges>().listen((event) {
      print("event.index");
      setState(() {
        widget.review = event.review;
      });
    });

    return CPRContainer(
      loadingWidget: p.Consumer<ReviewProvider>(
        builder: (context, provider, _) {
          return CPRLoading(
            loading: provider.busy,
          );
        },
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 1.82,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: ExtendedNetworkImageProvider(
                        OtherHelper.findPhotoReference(
                            size: 1024, photoRef: getPhotoRef()),
                        cache: true),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 100),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        widget.place.name ?? "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    CPRRating(widget.place),
                    CPRWorkingHours(widget.place),
                    ReviewSharingOptions(width: width, review: widget.review),
                    SimpleReviewCard(
                      review: widget.review,
                      loginedUser: sessionProvider.user!,
                    ),
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
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.place.address ?? "",
                                        style: TextStyle(
                                            color: widget.place.address != null
                                                ? Colors.black
                                                : Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    if (widget.place.address != null)
                                      GestureDetector(
                                        onTap: () {
                                          addAnalytics(
                                              AnalyticsTypes
                                                  .HOW_MANY_PEOPLE_LOOK_FOR_DIRECTIONS_FROM_CPR
                                                  .index,
                                              sessionProvider.user!.email);
                                          MapsLauncher.launchCoordinates(
                                              widget.place.coordinate!.latitude,
                                              widget
                                                  .place.coordinate!.longitude);
                                        },
                                        child: Text(
                                          "Directions",
                                          style: TextStyle(
                                              color: Get.theme.accentColor),
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
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.place.phone ?? "Phone Not Set",
                                        style: TextStyle(
                                            color: widget.place.phone != null
                                                ? Colors.black
                                                : Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    if (widget.place.phone != null)
                                      GestureDetector(
                                        onTap: () {
                                          if (ToolsValidation.isEmpty(
                                              widget.place.phone)) {
                                            ToolsToast.i(context,
                                                "No Phone Number Found!");
                                            return;
                                          }

                                          addAnalytics(
                                              AnalyticsTypes
                                                  .HOW_MANY_PEOPLE_CALL_THE_BUSINESS_FROM_CPR
                                                  .index,
                                              sessionProvider.user!.email);
                                          LauncherHelper.launchURL(
                                              "tel:" + widget.place.phone!);
                                        },
                                        child: Text(
                                          "Call Now",
                                          style: TextStyle(
                                              color: Get.theme.accentColor),
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
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.place.website ??
                                            "Website Not Set",
                                        style: TextStyle(
                                            color: widget.place.website != null
                                                ? Colors.black
                                                : Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    if (widget.place.website != null)
                                      GestureDetector(
                                        onTap: () {
                                          if (ToolsValidation.isEmpty(
                                              widget.place.website)) {
                                            ToolsToast.i(
                                                context, "No Website Found!");
                                            return;
                                          }

                                          addAnalytics(
                                              AnalyticsTypes
                                                  .HOW_MANY_PEOPLE_CLICK_ON_THE_BUSINESSES_WEBSITE_FROM_CPR
                                                  .index,
                                              sessionProvider.user!.email);
                                          LauncherHelper.launchURL(
                                              widget.place.website!);
                                        },
                                        child: Text(
                                          "View",
                                          style: TextStyle(
                                              color: Get.theme.accentColor),
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
                    RatingWaitingBadges(review: widget.review),
                    if (sessionProvider.user!.documentID ==
                        widget.review.userID)
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20, left: 16, right: 16),
                          child: p.Consumer<ReviewProvider>(
                            builder: (reviewContext, provider, _) {
                              return CPRButton(
                                onPressed: () async {
                                  deleteReview() async {
                                    // Navigator.pop(dialogContext);
                                    provider.startLoading();
                                    await provider.deleteReview(widget.review,
                                        sessionProvider.user!.documentID!);
                                    print("Delete social media review");
                                    await SocialPostHelper()
                                        .deleteReview(review: widget.review);
                                    await sessionProvider
                                        .loadCategorizedPlaces();
                                    await provider.loadLastReviewByPlace(
                                        widget.review.placeID!);
                                    Navigator.pop(context);
                                    provider.stopLoading();
                                  }

                                  showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return CPRConfirmDialog(
                                          title: "Delete Review",
                                          content:
                                              "Are you sure you want to delete this review?",
                                          proceedAction: deleteReview,
                                        );
                                      });
                                },
                                color: Colors.red,
                                width: double.infinity,
                                borderRadius:
                                    CPRDimensions.loginTextFieldRadius,
                                child: Center(
                                  child: Text(
                                    "Delete Review",
                                    style: CPRTextStyles.buttonSmallWhite
                                        .copyWith(fontSize: 14),
                                  ),
                                ),
                              );
                            },
                          )),
                  ],
                ),
              ),
            ),
            CPRBackButton(),
            CPRLikeReviewButton(widget.review, null, sessionProvider.user!)
          ],
        ),
      ),
    );
  }

  void addAnalytics(int analyticsType, visitorId) async {
    var analyticsCreate = new Analytics(
        analyticsType: analyticsType,
        placeId: widget.place.googlePlaceID,
        visitorId: visitorId,
        visitTime: Timestamp.fromDate(DateTime.now()),
        documentID: '');

    AnalyticsService analyticsService = new AnalyticsService();
    Analytics? a = await analyticsService.addAnalytic(analyticsCreate);
  }

  String? getPhotoRef() {
    /**
     * #abdo
        widget.review?.place?.firstGooglePhotoReference
     */
    if (widget.review.place == null) return null;
    return widget.review.place!.firstGooglePhotoReference;
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
