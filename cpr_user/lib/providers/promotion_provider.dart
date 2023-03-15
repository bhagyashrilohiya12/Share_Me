//import '../models/added_place.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/models/business_external_promotion.dart';
import 'package:cpr_user/models/business_internal_promotion.dart';
import 'package:cpr_user/services/business_external_promotions_service.dart';
import 'package:cpr_user/services/business_internal_promotions_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/external_promotion_coupon.dart';
import '../services/external_promotions_coupon_service.dart';

class PromotionProvider extends ChangeNotifier {
  User? firebaseUser;
  List<CPRBusinessInternalPromotion> internalPromotions = [];

  List<CPRBusinessExternalPromotion> externalPromotions = [];

  GeoPoint? currentLocation;

  var businessInternalPromotionsService = BusinessInternalPromotionsService();
  var businessExternalPromotionsService = BusinessExternalPromotionsService();
  var externalPromotionsCouponService = ExternalPromotionsCouponService();

  bool busy = false;

  void startLoading() {
    busy = true;
    notifyListeners();
  }

  void stopLoading() {
    busy = false;
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> addInternalPromotions(CPRBusinessInternalPromotion cPRBusinessInternalPromotion, File profileImage) async {
    await businessInternalPromotionsService.addInternalPromotions(cPRBusinessInternalPromotion, profileImage);
  }

  Future<List<CPRBusinessInternalPromotion>> getInternalPromotions() async {
    internalPromotions = await businessInternalPromotionsService.getInternalPromotions();
    notifyListeners();
    return internalPromotions;
  }

  Future<void> updateInternalPromotion(String docId, CPRBusinessInternalPromotion cPRBusinessInternalPromotion, File profileImage) async {
    await businessInternalPromotionsService.updateInternalPromotion(docId, cPRBusinessInternalPromotion, profileImage);
  }

  Future<void> deleteInternalPromotion(String docId, String pictureURL) async {
    await businessInternalPromotionsService.deleteInternalPromotion(docId, pictureURL: pictureURL);
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> addExternalPromotions(CPRBusinessExternalPromotion cPRBusinessExternalPromotion, File profileImage) async {
    await businessExternalPromotionsService.addExternalPromotions(cPRBusinessExternalPromotion, profileImage);
  }

  Future<List<CPRBusinessExternalPromotion>> getExternalPromotions() async {
    externalPromotions = await businessExternalPromotionsService.getExternalPromotions();
    notifyListeners();
    return externalPromotions;
  }

  Future<void> updateExternalPromotion(String docId, CPRBusinessExternalPromotion cPRBusinessInternalPromotion, File profileImage) async {
    await businessExternalPromotionsService.updateExternalPromotion(docId, cPRBusinessInternalPromotion, profileImage);
  }

  Future<void> deleteExternalPromotion(String docId, String pictureURL) async {
    await businessExternalPromotionsService.deleteExternalPromotion(docId, pictureURL: pictureURL);
  }

  Future<CPRExternalPromotionCoupon?> getUserExternalPromotionCouponCode(String promotionId, String placeId, String userId) async {
    return await externalPromotionsCouponService.getUserExternalPromotionCouponCode(promotionId, placeId, userId);
  }
}
