import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/models/follower_following.dart';
import 'package:cpr_user/models/review_like.dart';
import 'package:cpr_user/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ReviewLikeService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  Future<List<CPRReviewLike>> getLikedReviews(String yourId, List<String> reviewsId) async {
    List<CPRReviewLike> reviewLikes = [];
    try {
      QuerySnapshot querySnapshot =
      await db.collection(FirestorePaths.reviewLikeCollectionRoot).where("likerId", isEqualTo: yourId).get();
      if (querySnapshot.size > 0) {
        reviewLikes = querySnapshot.docs.map((snap) => CPRReviewLike.fromDocumentSnapshot(snap)).toList();
        reviewLikes = reviewLikes.where((element) => reviewsId.contains(element.review!.firebaseId!)).toList();
      }
    } catch (e) {
      print(e);
    }
    return reviewLikes;
  }


  Future<CPRReviewLike?> getLikedReview(String yourId, String reviewId) async {
    List<CPRReviewLike> reviewLikes = [];
    CPRReviewLike reviewLike = CPRReviewLike();
    try {
      QuerySnapshot querySnapshot =
      await db.collection(FirestorePaths.reviewLikeCollectionRoot).where("likerId", isEqualTo: yourId).get();
      if (querySnapshot.size > 0) {
        reviewLikes = querySnapshot.docs.map((snap) => CPRReviewLike.fromDocumentSnapshot(snap)).toList();
        reviewLike = reviewLikes.firstWhere((element) => element.review!.firebaseId! == reviewId);
      }
    } catch (e) {
      print(e);
    }
    return reviewLike;
  }

  Future<List<CPRReviewLike>> getLikesOfReview(String reviewId) async {
    List<CPRReviewLike> reviewLikes = [];
    try {
      QuerySnapshot querySnapshot =
      await db.collection(FirestorePaths.reviewLikeCollectionRoot).where("reviewId", isEqualTo: reviewId).get();
      if (querySnapshot.size > 0) {
        reviewLikes = querySnapshot.docs.map((snap) => CPRReviewLike.fromDocumentSnapshot(snap)).toList();
      }
    } catch (e) {
      print(e);
    }
    return reviewLikes;
  }


  Future<CPRReviewLike?> likeReview(CPRReviewLike cPRReviewLike) async {
    try {
      await db.collection(FirestorePaths.reviewLikeCollectionRoot).doc(cPRReviewLike.id).set(cPRReviewLike.toJSON());
      var result = await db.collection(FirestorePaths.reviewLikeCollectionRoot).doc(cPRReviewLike.id).get();
      return CPRReviewLike.fromDocumentSnapshot(result);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> unlikeReview(String documentID) async {
    try {
      await db.collection(FirestorePaths.reviewLikeCollectionRoot).doc(documentID).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}