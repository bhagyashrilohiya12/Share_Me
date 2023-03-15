import 'package:cloud_firestore/cloud_firestore.dart';

class PromotionWinReviews {
  String? reviewId;
  String? reward;
  String? userId;
  DateTime? created;
  
  PromotionWinReviews(
      {this.reviewId,
      this.reward,
      this.userId,
      this.created});

  factory PromotionWinReviews.fromJson(Map<String, dynamic> map) {

    var promotionWinReviews = PromotionWinReviews(
      reviewId: map["reviewId"] ?? null,
      reward: map["reward"] ?? null,
      userId: map["userId"] ?? null,
      created: map["created"]!=null ? (map['created'] as Timestamp).toDate() : null,
    );
    return promotionWinReviews;
  }

  Map<String, dynamic> toJSON() {
    return {
      "reviewId": reviewId,
      "reward": reward,
      "userId": userId,
      "created": Timestamp.fromDate(created!),
    };
  }
}
