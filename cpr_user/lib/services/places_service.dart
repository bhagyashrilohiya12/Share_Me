import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/constants/network_error_codes.dart';
import 'package:cpr_user/helpers/user_helper.dart';
import 'package:cpr_user/models/get_top_rate_near_palce.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/services/network_service.dart';

class PlacesService {
  var db = FirebaseFirestore.instance;

  Future<List<Place>> findAllPlaces() async {
    var results = await db.collection("places").get();

    return results.docs.map((f) => Place.fromJSON(f.data())).toList();
  }

  Future<Place?> findPlaceById(String googlePlaceId) async {
    try {
      QuerySnapshot querySnapshot = (await db
          .collection(FirestorePaths.placesCollectionRoot)
          .where("googlePlaceID", isEqualTo: googlePlaceId)
          .get());
      if (querySnapshot != null &&
          querySnapshot.docs != null &&
          querySnapshot.docs.length > 0) {
        Place p = Place.fromDocumentSnapshot(querySnapshot.docs[0]);
        return p;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String> findRandomReviewImage({int limit = 50}) async {
    try {
      var doc = await db
          .collection(FirestorePaths.placesCollectionRoot)
          .where("lastReviewImage", isGreaterThanOrEqualTo: "")
          .limit(limit)
          .get();
      var length = doc.docs.length;
      var randomIndex = math.Random().nextInt(length);
      var results = doc.docs[randomIndex];
      var review = Place.fromDocumentSnapshot(results);
      return review.lastReviewImage!;
    } catch (e) {}
    return "";
  }

  Future<List<Place>> findPlacesByCategory(String category,
      {int limit = 10}) async {
    try {
      var doc = await db.collection(FirestorePaths.placesCollectionRoot).where("categories", arrayContains: category).limit(limit).get();

      List<Place> list = doc.docs.map((f) {
        var place = Place.fromDocumentSnapshot(f);
        return place;
      }).toList();

      return list;
    } catch (e, st) {
      print(st);
    }
    return [];
  }

  Future<List<Place>> findPlacesByCategoryNearBy(String category, {int limit = 10,
    required GeoPoint userLocation, double radius = 100}) async {

    if (userLocation != null) {
      try {
        // var center = geo.point(
        //     latitude: userLocation.latitude, longitude: userLocation.longitude);
        try {
          var queryRef = await db
              .collection(FirestorePaths.placesCollectionRoot)
              .where('categories', arrayContains: category)
              .limit(limit)
              .get();

          // var documents = await geo
          //     .collection(collectionRef: queryRef)
          //     .within(center: center, radius: radius, field: 'location')
          //     .timeout(Duration(seconds: 3))
          //     .first;
          // List<Place> list = documents.map((f) {
          //   var place = Place.fromDocumentSnapshot(f);
          //   return place;
          // }).toList();
          // return list;
          return queryRef.docs
              .map((e) => Place.fromDocumentSnapshot(e))
              .toList();
        } catch (e) {
          print(e.runtimeType);
          print(e);
        }
        return [];
      } catch (e) {
        print(e);
      }
      return [];
    } else {
      try {
        var doc = await db
            .collection(FirestorePaths.placesCollectionRoot)
            .where("categories", arrayContains: category)
            .where("lastImage", isGreaterThan: "")
            .where("lastReviewId", isGreaterThan: "")
            .limit(limit)
            .get();

        List<Place> list = doc.docs.map((f) {
          var place = Place.fromDocumentSnapshot(f);
          return place;
        }).toList();

        return list;
      } catch (e, st) {
        print(e);
        //  print("\n\n\n\n\n");
      }
    }
    return [];
  }

  Future<List<Place>> findFavoritePlaces(String userId, {int limit = 10}) async {
    try {
      var doc = await db
          .collection(FirestorePaths.usersCollectionRoot)
          .doc(userId)
          .collection(FirestorePaths.usersFavoritesPlaces)
          // .where("place.lastReviewId", isGreaterThan: "")
          // .limit(limit)
          .get();
      return _loadPlacesFromUserCollection(doc.docs);
    } catch (e, st) {
      print(e);
    }
    return [];
  }

  Future<List<Review>> findReviewsPlaces(String userId, {int limit = 10}) async {
    try {
      var doc = await db
          .collection(FirestorePaths.reviewCollectionRoot)
          .where("userID", isEqualTo: userId)
          .where("archived", isEqualTo: false)
          .orderBy("when", descending: true)
          .limit(limit)
          .get();

      return _loadReviewFromUserCollection(doc.docs);
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<Review>> findDraftReviewsOfReviews(String userId, {int limit = 10}) async {
    try {
      var doc = await db
          .collection(FirestorePaths.usersCollectionRoot)
          .doc(userId)
          .collection(FirestorePaths.usersDraftReviews)
          .orderBy("creationTime", descending: true)
          .limit(limit)
          .get();

      return _loadReviewFromUserCollection(doc.docs);
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<Place>> findSaveForLaterPlaces(String userId, {int limit = 10}) async {
    var doc = await db
        .collection(FirestorePaths.usersCollectionRoot)
        .doc(userId)
        .collection(FirestorePaths.usersSaveForLaterPlaces)
        // .where("place.lastReviewId", isGreaterThan: "")
        // .limit(limit)
        .get();
    var list = _loadPlacesFromUserCollection(doc.docs);
    return list;
  }

  List<Place> _loadPlacesFromUserCollection(List<DocumentSnapshot> list) {
    // var results = list.map((snap) => snap.data).toList().map((data) => data()["place"] as Map).toList();
    return list.map((f) => Place.fromDocumentSnapshot(f)).toList();
  }

  List<Review> _loadReviewFromUserCollection(List<DocumentSnapshot> list) {
    //var results = list.map((snap) => snap.data).toList();

    return list.map((f) => Review.fromDocumentSnapshot(f)).toList();
  }

  Future<Place> addPlace(Place place) async {
    await db.collection(FirestorePaths.placesCollectionRoot).doc(place.googlePlaceID).set(place.toJSON());

    var result = await db.collection(FirestorePaths.placesCollectionRoot).doc(place.googlePlaceID).get();

    return Place.fromDocumentSnapshot(result);
  }

  Future<Place> updatePlaceDetail(String documentId, Map<String, dynamic> values) async {
    await db.collection(FirestorePaths.placesCollectionRoot).doc(documentId).update(values);
    var result = await db.collection(FirestorePaths.placesCollectionRoot).doc(documentId).get();

    return Place.fromDocumentSnapshot(result);
  }

  Future<void> refreshLocation() async {
    var s = await db.collection(FirestorePaths.placesCollectionRoot).get();
    List<Place> places = s.docs.map((doc) => Place.fromDocumentSnapshot(doc)).toList();
    for (var p in places) {
      try {
        db
            .collection(FirestorePaths.placesCollectionRoot)
            .doc(p.documentId)
            .update({"parentCategory": p.categories![0]});
      } catch (e) {}
    }
  }

  Future<void> findAllPlacesLastReviewIdAndImage() async {
    try {
      var docs = await db.collection(FirestorePaths.placesCollectionRoot).get();

      for (var d in docs.docs) {
        try {
          var place = Place.fromDocumentSnapshot(d);
          if (place.lastReviewId == null) {
            var reviewsDoc = await db
                .collection(FirestorePaths.reviewCollectionRoot)
                .where("placeID", isEqualTo: place.googlePlaceID)
                .orderBy("creationTime", descending: true)
                .get();

            List<Review> list = reviewsDoc.docs
                .map((r) {
                  return Review.fromDocumentSnapshot(r);
                })
                .where((re) =>
                    re.downloadURLs != null &&
                    re.downloadURLs!.isNotEmpty &&
                    re.creationTime != null)
                .toList();
            if (list != null && list.isNotEmpty) {
              var review = list[0];
              var data = {
                "lastImage": review.downloadURLs != null &&
                        review.downloadURLs!.isNotEmpty
                    ? review.downloadURLs![0]
                    : null,
                "lastReviewDate": review.creationTime,
                "lastReviewId": review.documentId
              };

              await db
                  .collection(FirestorePaths.placesCollectionRoot)
                  .doc(place.documentId)
                  .update(data);
            } else {}
          }
        } catch (ex) {
          print(ex);
        }
      }
    } catch (e) {}
  }

  void findAllPlacesAndUpdateReview() async {
    var docs = await db.collection(FirestorePaths.reviewCollectionRoot).get();

    var list = docs.docs.map((DocumentSnapshot i) {
      var review = Review.fromDocumentSnapshot(i);
      return review;
    }).toList();

    for (var r in list) {
      var s = await db
          .collection(FirestorePaths.usersCollectionRoot)
          .doc(r.userID)
          .collection(FirestorePaths.reviewCollectionRoot)
          .get();
      var subsList = s.docs.map((i) {
        return Review.fromDocumentSnapshot(i);
      }).toList();
      double realReviewRating = r.rating!;
      var weighting = findWeightingByReviews(subsList);
      realReviewRating = findRealReviewByWeighting(weighting, review: r.rating!);
      r.realRating = realReviewRating;
      await db
          .collection(FirestorePaths.reviewCollectionRoot)
          .doc(r.documentId)
          .update({"realRating": realReviewRating});
    }
  }

  void findAllPlacesAndUpdateTotalReview() async {
    var docs = await db.collection(FirestorePaths.placesCollectionRoot).get();

    var list = docs.docs.map((DocumentSnapshot i) {
      return Place.fromDocumentSnapshot(i);
    }).toList();

    for (var r in list) {
      var s = await db
          .collection(FirestorePaths.placesCollectionRoot)
          .doc(r.documentId)
          .collection(FirestorePaths.reviewCollectionRoot)
          .get();
      var subsList = s.docs.map((i) {
        return Review.fromDocumentSnapshot(i);
      }).toList();

      int total = subsList.length;
      double totalReview = 0.0;
      for (var subReview in subsList) {
        totalReview += subReview.realRating!;
      }

      await db
          .collection(FirestorePaths.placesCollectionRoot)
          .doc(r.documentId)
          .update({"totalReviews": total, "totalRating": totalReview});
    }
  }

  Future<Place?> findPlaceAndUpdateTotalReviewAndTotalRating(
      Place place) async {
    try {
      var s = await db
          .collection(FirestorePaths.reviewCollectionRoot)
          .where("placeID", isEqualTo: place.googlePlaceID)
          .get();
      var subsList = s.docs.map((i) {
        return Review.fromDocumentSnapshot(i);
      }).toList();

      int total = subsList.length;
      double totalRating = 0.0;
      for (var subReview in subsList) {
        totalRating += subReview.realRating!;
      }

      await db
          .collection(FirestorePaths.placesCollectionRoot)
          .doc(place.documentId)
          .update({"totalReviews": total, "totalRating": totalRating});

      var doc = await db
          .collection(FirestorePaths.placesCollectionRoot)
          .doc(place.documentId)
          .get();

      return Place.fromDocumentSnapshot(doc);
    } catch (e) {
      print("Error doing this task $e");
    }
    return null;
  }

  void findAllReviewsAndAssignPlaces() async {
    var docs = await db.collection(FirestorePaths.reviewCollectionRoot).get();

    var list = docs.docs.map((DocumentSnapshot i) {
      var review = Review.fromDocumentSnapshot(i);
      return review;
    }).toList();
    for (var r in list) {
      try {
        var place = Place.fromDocumentSnapshot(await db
            .collection(FirestorePaths.placesCollectionRoot)
            .doc(r.placeID)
            .get());
        db
            .collection(FirestorePaths.reviewCollectionRoot)
            .doc(r.documentId)
            .update({"place": place.toJSON()});
      } catch (e) {}
    }
  }

  Future<List<Place>?> getTopRateNearPlace(
      GeoPoint currentLocation, String category,
      {int total = 10, String topMode = "fill"}) async {
    var res = await networkService.callApi(
        url: BASE_URL +
            "app/getTopRateNearPlace?lat=${currentLocation.latitude}&lng=${currentLocation.longitude}&top=$total&topMode=$topMode&&category=${category}",
        requestMethod: RequestMethod.GET);

    if (res == NetworkErrorCodes.RECEIVE_TIMEOUT ||
        res == NetworkErrorCodes.CONNECT_TIMEOUT ||
        res == NetworkErrorCodes.SEND_TIMEOUT) {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text("Time Out Error !"),
      // ));
      return [];
    } else if (res == NetworkErrorCodes.SOCKET_EXCEPTION) {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text("No Internet Connection !"),
      // ));
      return [];
    } else if (res != null) {
      GetTopRateNearPalce topRateNearPalceTemp =
          new GetTopRateNearPalce.fromJson(res);
      if (topRateNearPalceTemp != null &&
          topRateNearPalceTemp.nearRatePlaces != null)
        return topRateNearPalceTemp.nearRatePlaces!
            .map((e) => e.place!)
            .toList();
      else
        return [];
    }
  }
}
