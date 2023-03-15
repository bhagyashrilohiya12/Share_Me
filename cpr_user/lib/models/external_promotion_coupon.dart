import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/models/business_external_promotion.dart';
import 'package:cpr_user/models/place.dart';

import '../constants/coupon_status.dart';

class CPRExternalPromotionCoupon {
  String? documentID;
  String? promotionId;
  String? placeId;
  String? userId;
  String? couponCode;
  int status;
  CPRBusinessExternalPromotion? externalPromotion; // use when get user coupons from server for show coupon details

  CPRExternalPromotionCoupon(
      { this.documentID,
        required this.promotionId ,
        required this.placeId,
        required this.userId,
        required this.couponCode,
        required this.status
      });

  factory CPRExternalPromotionCoupon.fromJson(Map<String, dynamic> map) {
    var owner = CPRExternalPromotionCoupon(
      promotionId: map["promotionId"],
      placeId: map["placeId"],
      userId: map["userId"],
      couponCode: map["couponCode"],
      status: map["status"],
    );
    return owner;
  }

  factory CPRExternalPromotionCoupon.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    var employee = CPRExternalPromotionCoupon.fromJson(map);
    employee.documentID = doc.id;
    return employee;
  }

  Map<String, dynamic> toJSON() {
    return {
      "promotionId": promotionId,
      "placeId": placeId,
      "userId": userId,
      "couponCode": couponCode,
      "status": status,
    };
  }
}
