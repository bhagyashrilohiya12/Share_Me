import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/helpers/file_helper.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/models/business_external_promotion.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/external_promotion_coupon.dart';

class ExternalPromotionsCouponService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  Future<void> addExternalPromotionCoupon(CPRExternalPromotionCoupon cPRExternalPromotionCoupon) async {
    return db
        .collection(FirestorePaths.externalPromotionCouponsCollectionRoot)
        .add(cPRExternalPromotionCoupon.toJSON())
        .then((value) =>
        print("External Promotion Coupon Added")
    ).catchError((error) => print("Failed to add External Promotion Coupon: $error"));
  }

  Future<CPRExternalPromotionCoupon?> getUserExternalPromotionCouponCode(String promotionId,
  String placeId,String userId) async {

    QuerySnapshot q =  await db
        .collection(FirestorePaths.externalPromotionCouponsCollectionRoot)
        .where("promotionId",isEqualTo: promotionId)
        .where("placeId",isEqualTo: placeId)
        .where("userId",isEqualTo: userId).get();

    if(q.docs.length>0)
      return CPRExternalPromotionCoupon.fromDocumentSnapshot(q.docs.first);
    else
       return null;
  }

  Future<List<CPRExternalPromotionCoupon>> getUserCoupons(String userId) async {
    List<CPRExternalPromotionCoupon> coupons = [];
    QuerySnapshot q =  await db
        .collection(FirestorePaths.externalPromotionCouponsCollectionRoot)
        .where("userId",isEqualTo: userId).get();

    if(q.docs.isNotEmpty) {
      for (var element in q.docs) {
        CPRExternalPromotionCoupon coupon = CPRExternalPromotionCoupon.fromDocumentSnapshot(element);

        DocumentSnapshot documentSnapshot =  await db
            .collection(FirestorePaths.externalPromotionsCollectionRoot).doc(coupon.promotionId).get();
        coupon.externalPromotion = CPRBusinessExternalPromotion.fromDocumentSnapshot(documentSnapshot);

        coupons.add(coupon);
      }
    }
    return coupons;
  }


}
