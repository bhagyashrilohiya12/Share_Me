import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/constants/review_sorting.dart';
import 'package:cpr_user/helpers/file_helper.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/main.dart';
import 'package:cpr_user/models/events/review_changes.dart';
import 'package:cpr_user/models/events/review_delete.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ReviewService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  Future<List<Review>> findLastReviewsByPlaceId(String placeId,
      {int limit = 5, String? exclude, String? sort, bool? desc}) async {
    sort ??= ReviewSorting.CREATION_TIME; // = ReviewSorting.CREATION_TIME

    var doc = await db
        .collection(FirestorePaths.reviewCollectionRoot)
        .where("placeID", isEqualTo: placeId)
        .where("archived", isNotEqualTo: true)
        .limit(limit)
        .get();
    var results = doc.docs.map((f) {
      var review = Review.fromDocumentSnapshot(f);
      return review;
    }).toList();
    if (exclude != null && exclude.isNotEmpty) {
      results.removeWhere((e) => e.documentId == exclude);
    }
    return results;
  }

  Future<List<Review>> searchReviewByText(String text) async {
    var doc = await db
        .collection(FirestorePaths.reviewCollectionRoot)
        .where("fullReview", isGreaterThanOrEqualTo: text)
        .get();
    var results = doc.docs.map((f) {
      var review = Review.fromDocumentSnapshot(f);
      return review;
    }).toList();
    return results;
  }

  Future<List<Review>> findReviewsByUser(CPRUser user) async {
    List<Review> list = [];
    try {
      var docs = await db
          .collection(FirestorePaths.usersCollectionRoot)
          .doc(user.documentID)
          .collection(FirestorePaths.usersReviewsPlaces)
          .where("archived", isEqualTo: false)
          .orderBy("when", descending: true)
          .get();

      list = docs.docs.map((snap) => Review.fromDocumentSnapshot(snap)).toList();
    } catch (e) {
      print(e);
    }

    return list;
  }

  Future<List<String>?> findReviewsThatUsePromotionByUser(CPRUser user) async {
    List<Review> list = [];
    try {
      var docs = await db
          .collection(FirestorePaths.usersReviewsPlaces)
          // .where("userID", isEqualTo: "qicitupa@forexlist.in" )
          //  .where("userID", isEqualTo: "jameskaycoder@gmail.com" )
          .where("userID", isEqualTo: user.email)
          .where("promotionDocId", isGreaterThan: '')
          .get();



      list = docs.docs.map((snap) => Review.fromDocumentSnapshot(snap)).toList();
      // list.sort((Review a, Review b) => a.when?.compareTo(b!.when));
      // return list != null ? list.map((e) => e?.promotion?.id).toList() : [];

      if( list == null ) {
        Log.i( "findReviewsThatUsePromotionByUser() - listPromotionId - list == null - stop !"   );
        return null;
      }
      if( user.reviews == null ) {
        Log.i( "findReviewsThatUsePromotionByUser() - listPromotionId - user.reviews == null - stop !"   );
        return null;
      }

      List<String> listPromotionId = [];

      user.reviews!.forEach((element) {
        if (element.promotion != null) {
          listPromotionId.add(element.promotion!.id!);
        }
      });

      Log.i( "findReviewsThatUsePromotionByUser() - listPromotionId: " + listPromotionId.toString() );

      return listPromotionId;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Review>> getUserReviewsList(CPRUser user) async {
    List<Review> list = [];
    try {
      var docs = await db.collection(FirestorePaths.reviewCollectionRoot).where("userID", isEqualTo: user.email).get();

      list = docs.docs.map((snap) => Review.fromDocumentSnapshot(snap)).toList();
    } catch (e) {
      print(e);
    }

    return list;
  }

  Future<List<Review>> getPromotionReviewsList(String promotionDocId) async {
    List<Review> list = [];
    try {
      var docs = await db.collection(FirestorePaths.reviewCollectionRoot).where("promotionDocId", isEqualTo: promotionDocId).get();
      list = docs.docs.map((snap) => Review.fromDocumentSnapshot(snap)).toList();
    } catch (e) {
      print(e);
    }

    return list;
  }

  Future<List<Review>> getReviewsFromIdsList(List<String> ids) async {
    List<Review> list = [];
    try {
      var docs = await db.collection(FirestorePaths.reviewCollectionRoot).where("firebaseId", whereIn: ids).get();
      list = docs.docs.map((snap) => Review.fromDocumentSnapshot(snap)).toList();
    } catch (e) {
      print(e);
    }

    return list;
  }

  Future<Review> findReview(String documentID) async {
    var review = Review.fromDocumentSnapshot((await db.collection(FirestorePaths.reviewCollectionRoot).doc(documentID).get()));

    return review;
  }

  Future<Review> createReview(Review? review, CPRUser user, {List<File>? images, List<File>? videos}) async {
    var response = await db.collection(FirestorePaths.reviewCollectionRoot).add(
          review!.toJSON()
        );

    if (images != null) {
      // var ref = storage.ref().child("reviews_images/" + response.documentID);
      for (var image in images) {
        try {
          String uuid = OtherHelper.getUUID().toUpperCase();
          String path = "reviews_images/${response.id}/$uuid${FileHelper.getExtension(image)}";
          var ref = storage.ref().child(path);
          UploadTask task = ref.putFile(image);
          await task.whenComplete(() => null);
          var url = await ref.getDownloadURL();

          if (review.downloadURLs == null) review.downloadURLs = [];

          if (review.images == null) review.images = [];

          review.images!.add(uuid);
          review.downloadURLs!.add(url);
        } catch (e) {}
      }
    }
    if (videos != null) {
      for (var video in videos) {
        try {
          String uuid = OtherHelper.getUUID().toUpperCase();
          String path = "reviews_videos/${response.id}/$uuid${FileHelper.getExtension(video)}";
          var ref = storage.ref().child(path);
          UploadTask task = ref.putFile(video);
          await task.whenComplete(() => null);
          var url = await ref.getDownloadURL();

          if (review.videoDownloadURLs == null) review.videoDownloadURLs = [];

          if (review.videos == null) review.videos = [];

          review.videos!.add(uuid);
          review.videoDownloadURLs!.add(url);
        } catch (e) {}
      }
    }
    review.firebaseId = response.id;

    try {
      Place? place = Place.fromDocumentSnapshot(await db
          .collection(FirestorePaths.placesCollectionRoot)
          .doc(review.placeID)
          .get());
      if (place.totalReviews == null || place.totalRating == null) {
        place = await PlacesService().findPlaceAndUpdateTotalReviewAndTotalRating(place);
      }

      place!.totalRating += review.realRating;

      /**
       * #abdo
       */
      place.totalReviews  = place.totalReviews! +  1 ;

      //await db.runTransaction(transactionHandler)
      if (place.location == null) {
        if (place.coordinate != null) {
          place.generateLocationByCoordinate();
        }
      }
      place.lastReviewId = review.firebaseId!;
      place.lastReviewImage = review.downloadURLs![0];
      place.lastReviewDate = DateTime.now();

      await db.collection(FirestorePaths.placesCollectionRoot).doc(place.documentId).update(place.toJSON());
      review.place = place;
    } catch (e) {
      print(e.toString());
    }

    await db.collection(FirestorePaths.reviewCollectionRoot).doc(response.id).set(review.toJSON());
    try {
      db
          .collection(FirestorePaths.usersCollectionRoot)
          .doc(user.email)
          .collection(FirestorePaths.usersDraftReviews)
          .doc(review.placeID)
          .delete();
    } catch (e) {
      print(e.toString());
    }
    return review;
  }

  Future<Review> editReview(Review review, CPRUser user,
      {required List<File> images, required List<String> imagesToRemove,
        required List<File> videos,
        required List<String> videosToRemove}) async {

    if (imagesToRemove != null && imagesToRemove.isNotEmpty) {
      for (var path in imagesToRemove) {
        try {
          var ref = storage.refFromURL(path);
          ref.delete();
        } catch (e) {}
      }
    }
    if (images != null) {
      // var ref = storage.ref().child("reviews_images/" + response.documentID);
      if (review.downloadURLs == null) {
        review.downloadURLs = [];
      }

      if (review.images == null) {
        review.images = [];
      }
      for (var image in images) {
        try {
          String uuid = OtherHelper.getUUID().toUpperCase();
          String path = "reviews_images/${review.documentId}/$uuid${FileHelper.getExtension(image)}";
          var ref = storage.ref().child(path);
          UploadTask task = ref.putFile(image);
          await task.whenComplete(() => null);
          var url = await ref.getDownloadURL();

          review.images!.add(uuid);
          review.downloadURLs!.add(url);
        } catch (e) {}
      }
    }
    if (videosToRemove != null && videosToRemove.isNotEmpty) {
      for (var path in videosToRemove) {
        try {
          var ref = storage.refFromURL(path);
          ref.delete();
        } catch (e) {}
      }
    }
    if (videos != null) {
      // var ref = storage.ref().child("reviews_images/" + response.documentID);
      if (review.videoDownloadURLs == null) {
        review.videoDownloadURLs = [];
      }

      if (review.videos == null) {
        review.videos = [];
      }
      for (var video in videos) {
        try {
          String uuid = OtherHelper.getUUID().toUpperCase();
          String path = "reviews_videos/${review.documentId}/$uuid${FileHelper.getExtension(video)}";
          var ref = storage.ref().child(path);
          UploadTask task = ref.putFile(video);
          await task.whenComplete(() => null);
          var url = await ref.getDownloadURL();

          review.videos!.add(uuid);
          review.videoDownloadURLs!.add(url);
        } catch (e) {}
      }
    }
    review.firebaseId = review.documentId;
    try {
      Place? place = Place.fromDocumentSnapshot(await db.collection(FirestorePaths.placesCollectionRoot).doc(review.placeID).get());
      if (place.totalReviews == null || place.totalRating == null) {
        place = await PlacesService().findPlaceAndUpdateTotalReviewAndTotalRating(place);
      }
      print("Previous = ${review.previousRealRating} | actual = ${review.realRating}");
      print("Place infor from server ${place!.toRatingJSON()}");
      if (review.previousRealRating != review.realRating) {
        place.totalRating -= review.previousRealRating;
        place.totalRating += review.realRating;
      }

      //await db.runTransaction(transactionHandler)
      if (place.location == null) {
        if (place.coordinate != null) {
          place.generateLocationByCoordinate();
        }
      }

      db.runTransaction((tran) async {
        await db.collection(FirestorePaths.reviewCollectionRoot).doc(review.documentId).update(review.toJSON());
        await db.collection(FirestorePaths.placesCollectionRoot).doc(place!.documentId).update(place.toRatingJSON());

        return tran;
      });
      print("Updating place ID (${place.documentId}) with data: ${place.toRatingJSON()}");
      review.place = place;
    } catch (e) {
      print("error $e");
    }
    eventBus.fire(ReviewChanges(review));
    return review;
  }

  Future deleteReview(Review review, String userId) async {
    Review reviewTemp = review;
    reviewTemp.archived = true;
    try {
      await db.collection(FirestorePaths.reviewCollectionRoot).doc(review.documentId).update(reviewTemp.toJSON());
      eventBus.fire(ReviewDelete(review));
    } catch (e) {
      try {
        await db
            .collection(FirestorePaths.usersCollectionRoot)
            .doc(userId)
            .collection(FirestorePaths.reviewCollectionRoot)
            .doc(review.documentId)
            .update(reviewTemp.toJSON());
      } catch (e) {}
      try {
        await db
            .collection(FirestorePaths.placesCollectionRoot)
            .doc(review.placeID)
            .collection(FirestorePaths.reviewCollectionRoot)
            .doc(review.documentId)
            .update(reviewTemp.toJSON());
      } catch (e) {}
    }
  }

  Future saveDraftReview(Review review, String userId, {required List<File> images, required List<File> videos,bool isUpdate = false}) async {
    if (review.placeID == null) {
      throw new Exception("Place Id is not provided");
    }

    if (userId == null) {
      throw new Exception("User not provided");
    }

    if(isUpdate && review.images!=null && review.images!.length>0){ //remove previous images
      review.images!.forEach((element) async {
        try {
          var p = storage.refFromURL(element);
          await p.delete();
        } catch (e) {
          print(e);
        }
      });
    }

    if (images != null)
      for (var image in images) {
        try {
          String uuid = OtherHelper.getUUID().toUpperCase();

          String path = "drafted_images/$userId/$uuid${FileHelper.getExtension(image)}";
          var ref = storage.ref().child(path);
          UploadTask task = ref.putFile(image);
          await task.whenComplete(() => null);
          var url = await ref.getDownloadURL();
          if (review.images == null) {
            review.images = [];
          }
          if (review.downloadURLs == null) {
            review.downloadURLs = [];
          }
          review.images!.add(uuid);
          review.downloadURLs!.add(url);
        } catch (e) {
          print(e);
          print(StackTrace.current);
        }
      }
    if (videos != null)
      for (var video in videos) {
        try {
          String uuid = OtherHelper.getUUID().toUpperCase();

          String path = "drafted_videos/$userId/$uuid${FileHelper.getExtension(video)}";
          var ref = storage.ref().child(path);
          UploadTask task = ref.putFile(video);
          await task.whenComplete(() => null);
          var url = await ref.getDownloadURL();
          if (review.videos == null) {
            review.videos = [];
          }
          if (review.downloadURLs == null) {
            review.downloadURLs = [];
          }
          review.videos!.add(uuid);
          if (review.videoDownloadURLs == null) review.videoDownloadURLs = [];
          review.videoDownloadURLs!.add(url);
        } catch (e) {
          print(e);
          print(StackTrace.current);
        }
      }
    if(isUpdate)
    await db
        .collection(FirestorePaths.usersCollectionRoot)
        .doc(userId)
        .collection(FirestorePaths.usersDraftReviews)
        .doc(review.documentId).update(review.toJSON());
    else
      await db
          .collection(FirestorePaths.usersCollectionRoot)
          .doc(userId)
          .collection(FirestorePaths.usersDraftReviews)
          .add(review.toJSON());
  }

  Future<Review?> findDraftReviewByUserAndAndId(reviewId,userId) async {
    var doc =
        await db
        .collection(FirestorePaths.usersCollectionRoot)
        .doc(userId)
        .collection(FirestorePaths.usersDraftReviews)
        .doc(reviewId)
        .get();
    var data = doc.data;
    if (data == null) {
      return null;
    }
    return Review.fromDocumentSnapshot(doc);
  }

  Future<bool?> deleteDraftReview(Review review,List<String> images, String userId) async {

    try {
      if (images != null)
            for (var image in images) {
              try {
                String uuid = OtherHelper.getUUID().toUpperCase();

                String path = "drafted_images/$userId/$uuid${FileHelper.getExtensionFromAddress(image)}";
                var ref = storage.ref().child(path);
                ref.delete();
              } catch (e) {
                print(e);
                print(StackTrace.current);
              }
            }
    } catch (e) {
      print(e);
    }

    try {
      await db
          .collection(FirestorePaths.usersCollectionRoot)
          .doc(userId)
          .collection(FirestorePaths.usersDraftReviews)
          .doc(review.documentId)
          .delete()
          .then((value) {
        return true;
      });
    } catch (e) {
      return false;
    }
  }
}
