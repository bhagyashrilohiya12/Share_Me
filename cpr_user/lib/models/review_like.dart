import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/user.dart';

class CPRReviewLike {
  String? documentID;
  String? id;
  String? likerId;
  String? reviewId;
  CPRUser? liker;
  Review? review;


  CPRReviewLike({this.id, this.likerId, this.reviewId, this.liker, this.review}){
    if (id == null) id = OtherHelper.getUUID().toUpperCase();
  }

  factory CPRReviewLike.fromJson(Map<String, dynamic> map) {
    var follow = CPRReviewLike(
      id: map["id"] ?? null,
      likerId: map["likerId"] ?? null,
      reviewId: map["reviewId"] ?? null,
      liker: map["liker"] != null ? CPRUser.fromJson(map["liker"]) : null,
      review: map["review"] != null ? Review.fromJSON(map["review"]) : null,
    );
    return follow;
  }

  factory CPRReviewLike.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    var reviewLike = CPRReviewLike.fromJson(map);
    reviewLike.documentID = doc.id;
    return reviewLike;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "likerId": likerId,
      "reviewId": reviewId,
      "liker": liker != null ? liker!.toJSON() : null,
      "review": review != null ? review!.toJSON() : null,
    };
  }
}