import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/models/promotion_win_reviews.dart';
import 'package:cpr_user/helpers/other_helper.dart';

class CPRBusinessInternalPromotion {
  String? documentID;
  String? id;
  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  List<String>? rewards;
  List<PromotionWinReviews> winReviews;
  String? picture;
  String? pictureURL;
  String? placeId;
  String? ownerEmail;

  CPRBusinessInternalPromotion(
      {required this.documentID,
        required this.id,
        required this.title,
        required this.description,
        required this.startDate,
        required this.endDate,
        required this.rewards,
        required this.winReviews,
        required this.picture,
        required this.pictureURL,
        required this.placeId,
        required this.ownerEmail}) {
    if (id == null) id = OtherHelper.getUUID().toUpperCase();
  }

  factory CPRBusinessInternalPromotion.fromJson(Map<String, dynamic> map) {
    List<String>? tempRewards = [];
    if (map['rewards'] != null) {
      tempRewards = <String>[];
      map['rewards'].forEach((v) {
        tempRewards!.add(v);
      });
    }
    List<PromotionWinReviews> tempWinReviews = [];
    if (map['winReviews'] != null) {
      tempWinReviews = <PromotionWinReviews>[];
      map['winReviews'].forEach((v) {
        tempWinReviews.add(PromotionWinReviews.fromJson(v));
      });
    }

    var owner = CPRBusinessInternalPromotion(
      id: map["id"] ?? null,
      title: map["title"] ?? null,
      description: map["description"] ?? null,
      startDate: map["startDate"] != null ? (map['startDate'] as Timestamp).toDate() : null,
      endDate: map["endDate"] != null ? (map['endDate'] as Timestamp).toDate() : null,
      rewards: tempRewards,
      winReviews: tempWinReviews,
      picture: map["picture"] ?? null,
      pictureURL: map["pictureURL"] ?? null,
      placeId: map["placeId"] ?? null,
      ownerEmail: map["ownerEmail"] ?? null, documentID: '',
    );
    return owner;
  }

  factory CPRBusinessInternalPromotion.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    var employee = CPRBusinessInternalPromotion.fromJson(map);
    employee.documentID = doc.id;
    return employee;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "startDate": Timestamp.fromDate(startDate!),
      "endDate": Timestamp.fromDate(endDate!),
      "rewards": rewards != null ? this.rewards!.map((v) => v).toList() : null,
      "winReviews": winReviews != null ? this.winReviews.map((v) => v.toJSON()).toList() : null,
      "picture": picture,
      "pictureURL": pictureURL,
      "placeId": placeId,
      "ownerEmail": ownerEmail,
    };
  }
}
