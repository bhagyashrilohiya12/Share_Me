import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/constants/cpr_urls.dart';
import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/helpers/string_helper.dart' as stringHelper;
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/cpr_search.dart';
import 'package:cpr_user/pages/user/home_page/components/external_promotions_list.dart';
import 'package:cpr_user/pages/user/home_page/components/user_coupons_list.dart';
import 'package:cpr_user/pages/user/search_places_and_reviews/search_places_and_reviews_page.dart';
import 'package:cpr_user/providers/places_provider.dart';
import 'package:cpr_user/providers/review_provider.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart' as p;

class CategorizedPlacesList extends StatelessWidget {
  final MainCategory category;
  List<dynamic>? places;

  CategorizedPlacesList({required this.category});

  SessionProvider? sessionProvider;

  BuildContext? context;
  List<Widget> getListChildren = [];
  String? displayName;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    displayName = MainCategoryUtil.getDisplayName(category);
    //  Log.i( "CategorizedPlacesList - build - displayName: " + displayName.toString() );

    sessionProvider = p.Provider.of<SessionProvider>(context, listen: false);

    var listPlaceFromSession = sessionProvider!.places[category];
    if (listPlaceFromSession != null) {
      places = listPlaceFromSession;
    }

//    if (sessionProvider.places[category] == null || sessionProvider.places[category].isEmpty) {
//      return Container(child: Text('No places for category $category', style: TextStyle(color: Colors.white)));
//    }

    getListChildren = getCategoryValueListHorizontal();

    if (category == MainCategory.promotions) {
      return ExternalPromotionsList();
    } else if (category == MainCategory.coupons) {
      return UserCouponsList();
    } else {
      return normalTypeOfCategory();
    }
  }

  Widget normalTypeOfCategory() {
    return Container(
      height: 170,
      padding: const EdgeInsets.only(left: 16, right: 16),
      //color: Colors.cyan,
      child: Column(
        children: <Widget>[
          titleBar(),
          Expanded(
            child: Builder(
              builder: (context) {
                return ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(top: 10),
                    children: getListChildren);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget titleBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          MainCategoryUtil.getDisplayName(category),
          style: CPRTextStyles.smallHeaderBoldDarkBackground,
        ),
        GestureDetector(
          onTap: () async {
            _clickOnRow();
          },
          child: places == null || places!.isEmpty
              ? const SizedBox()
              : Text(
                  "See all",
                  style: CPRTextStyles.smallHeaderNormalDarkBackground,
                ),
        ),
      ],
    );
  }

  List<Widget> getCategoryValueListHorizontal() {
    List<Widget> children = [];
    if (places != null) {
      // Log.i( "getCategoryValueListHorizontal() - places: " + places.toString() + " /size: " + places!.length.toString() );
      if (category == MainCategory.myReviews) {
        children = places!
            .map((f) => ReviewMiniCard(
                  review: f as Review,
                  categoryName: MainCategoryUtil.getDisplayName(category),
                  userLocation: sessionProvider!.currentLocation!,
                ))
            .toList();
      } else if (category == MainCategory.myDraftReviews) {
        //  Log.i( "getCategoryValueListHorizontal() - case (myDraftReviews)  "  );

        children = places!
            .map((f) => ReviewMiniCard(
                  review: f as Review,
                  categoryName: MainCategoryUtil.getDisplayName(category),
                  userLocation: sessionProvider!.currentLocation!,
                  isDraftReview: true,
                ))
            .toList();
      } else {
        // Log.i( "getCategoryValueListHorizontal() - case (else)  "  );

        children = places!
            .map((f) => PlaceMiniCard(
                  place: f as Place,
                  isReview: category != MainCategory.myFavoritePlaces && category != MainCategory.saveForLaterPlaces,
                  categoryName: MainCategoryUtil.getDisplayName(category),
                  userLocation: sessionProvider!.currentLocation!,
                ))
            .toList();
      }
    } else if (places == null || places!.isEmpty) {
      //  Log.i( "getCategoryValueListHorizontal() - case (places == null)  "  );

      children = [
        Container(
          width: MediaQuery.of(context!).size.width,
          child: const Center(
            child: Text(
              "No results found",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        )
      ];
    }
    // Log.i( "getCategoryValueListHorizontal() - children: " + children.toString() + "/displayName: " + displayName.toString() );
    return children;
  }

  void _clickOnRow() {
    var subtitle = 'List of all the ${displayName!.toLowerCase()} that has been reviewed.';
    var placeProvider = p.Provider.of<PlacesProvider>(context!, listen: false);
    var searchComponent;
    switch (category) {
      case MainCategory.myReviews:
        sessionProvider!.startLoading();
        searchComponent = CPRSearch(
            title: displayName,
            subtitle: 'List of all ${displayName!.toLowerCase()}',
            reviews: places!.map((f) => f as Review).toList(),
            currentLocation: sessionProvider!.currentLocation!);
        sessionProvider!.stopLoading();
        showModalBottomSheet(
            context: context!,
            barrierColor: Colors.white.withOpacity(0.25),
            elevation: 7,
            isScrollControlled: true,
            builder: (bottomSheetContext) {
              return Container(
                child: searchComponent,
                height: MediaQuery.of(context!).size.height * .85,
              );
            });
        break;
      case MainCategory.myDraftReviews:
        sessionProvider!.startLoading();
        searchComponent = CPRSearch(
          title: displayName,
          subtitle: 'List of all ${displayName!.toLowerCase()}',
          reviews: sessionProvider!.places[category]!.map((f) => f as Review).toList(),
          currentLocation: sessionProvider!.currentLocation!,
          isDraftReview: true,
        );
        sessionProvider!.stopLoading();
        showModalBottomSheet(
            context: context!,
            barrierColor: Colors.white.withOpacity(0.25),
            elevation: 7,
            isScrollControlled: true,
            builder: (bottomSheetContext) {
              return Container(
                child: searchComponent,
                height: MediaQuery.of(context!).size.height * .85,
              );
            });
        break;
      case MainCategory.saveForLaterPlaces:
      case MainCategory.myFavoritePlaces:
        sessionProvider!.startLoading();
        var sub = "List of all ";
        if (category == MainCategory.saveForLaterPlaces) {
          sub = sub + "the ${displayName!.toLowerCase()}";
        } else {
          sub += displayName!.toLowerCase();
        }
        searchComponent = CPRSearch(
            title: displayName,
            subtitle: sub,
            reviews: places!.map((f) => f as Place).toList(),
            currentLocation: sessionProvider!.currentLocation!);
        sessionProvider!.stopLoading();
        showModalBottomSheet(
            context: context!,
            barrierColor: Colors.white.withOpacity(0.25),
            elevation: 7,
            isScrollControlled: true,
            builder: (bottomSheetContext) {
              return Container(
                child: searchComponent,
                height: MediaQuery.of(context!).size.height * .85,
              );
            });
        break;
      default:
        Get.to(SearchPlacesAndReviewsPage(category: category, categoryName: null));
        // var list = await placeProvider.findPlacesByCategory(sessionProvider.currentLocation, category);
        // searchComponent = CPRSearch<Place>(
        //     title: MainCategoryUtil.getDisplayName(category),
        //     subtitle: subtitle,
        //     reviews: list,
        //     currentLocation: sessionProvider.currentLocation);
        break;
    }
  }
}

class PlaceMiniCard extends StatelessWidget {
  final Place place;
  final String categoryName;
  final GeoPoint? userLocation;
  final bool isReview;
  final bool showReviewImage;

  const PlaceMiniCard({
    this.isReview = true,
    this.showReviewImage = true,
    required this.categoryName,
    this.userLocation,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    var reviewProvider = p.Provider.of<ReviewProvider>(context, listen: false);

    var placesProvider = p.Provider.of<PlacesProvider>(context);
    var homeProvider = p.Provider.of<SessionProvider>(context, listen: false);
    var pic =
        "${PlacesAPI.googlePhotoReferenceUrl}?key=${PlacesAPI.googlePlacesKey}&photoreference=${place.firstGooglePhotoReference}&maxwidth=${130}";
    if (showReviewImage) {
      try {
        if (place.lastReviewImage != null) {
          pic = place.lastReviewImage!;
        }
      } catch (e) {}
    }

    // print("pic " + pic);
    // var color = Random().nextInt(2) == 1 ? Colors.red : Colors.blue;

    return GestureDetector(
      onTap: () async {
        homeProvider.startLoading();
        try {
          var updatedReview;
          var updatedPlace = await placesProvider.findPlace(place.googlePlaceID!);
          if (isReview) {
            updatedReview = await reviewProvider.findReview(updatedPlace!.lastReviewId!);
          }

          Navigator.of(context)
              .push(CPRRoutes.placesDetailPage(updatedPlace!, review: updatedReview, userLocation: userLocation));
          homeProvider.stopLoading();
        } catch (e) {
          print(e);
          homeProvider.stopLoading();
        }
      },
      child: Container(
        // color: color,
        margin: const EdgeInsets.only(right: CPRDimensions.homeMarginBetweenCard),
        height: 100,
        width: 100,
        child: Column(children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 100,
              width: 160,
              child: pic != null
                  ? ExtendedImage.network(
                      pic,
                      fit: BoxFit.cover,
                      cache: true,
                    )
                  : const SizedBox(),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            width: 160,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    stringHelper.formatMaxString(place.name ?? "", 10),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    stringHelper.formatMaxString(place.address ?? "", 20),
                    style: CPRTextStyles.cardSubtitle.copyWith(fontSize: 10),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class ReviewMiniCard extends StatelessWidget {
  final Review review;
  final String categoryName;
  final GeoPoint? userLocation;
  final isDraftReview;

  ReviewMiniCard({
    required this.categoryName,
    this.userLocation,
    required this.review,
    this.isDraftReview = false,
  });

  @override
  Widget build(BuildContext context) {
    var homeProvider = p.Provider.of<SessionProvider>(context, listen: false);
    var pic = "";
    if (review.downloadURLs != null && review.downloadURLs!.isNotEmpty) {
      pic = review.downloadURLs![0];
    } else {
      pic =
          "${PlacesAPI.googlePhotoReferenceUrl}?key=${PlacesAPI.googlePlacesKey}&photoreference=${review.place?.firstGooglePhotoReference}&maxwidth=${130}";
    }
    return GestureDetector(
      onTap: () async {
        if (!isDraftReview) {
          homeProvider.startLoading();
          var updatedPlace = await PlacesService().findPlaceById(review.placeID!);
          Navigator.of(context).push(CPRRoutes.reviewDetailPage(review, updatedPlace!, userLocation: userLocation));
          homeProvider.stopLoading();
        } else {
          //todo: previous code.
          // CPRRoutes.createReview(context,
          //     place: review.place,
          //     usePromotion: review.promotionDocId != null,
          //     canDeleteDraftReview: true);

          //todo:16/09/22 new code..change in data passing.
          CPRRoutes.createReview2(context,
              review: review,
              place: review.place,
              usePromotion: review.promotionDocId != null,
              canDeleteDraftReview: true);
        }
      },
      child: Container(
        height: 100,
        width: 100,
        margin: const EdgeInsets.only(right: CPRDimensions.homeMarginBetweenCard),
        child: Column(children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 100,
              width: 100,
              child: pic != null
                  ? ExtendedImage.network(
                      pic,
                      fit: BoxFit.cover,
                      cache: true,
                    )
                  : const SizedBox(),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  stringHelper.formatMaxString(review.place!.name!, 10),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
                Text(
                  stringHelper.formatMaxString(review.place!.address!, 20),
                  style: CPRTextStyles.cardSubtitle.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
