import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/helpers/file_helper.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/models/business_external_promotion.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BusinessExternalPromotionsService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  Future<void> addExternalPromotions(CPRBusinessExternalPromotion cPRBusinessExternalPromotion, File profileImage) async {
    if (profileImage != null) {
      String uuid = OtherHelper.getUUID().toUpperCase();
      String path = "promotion_images/$uuid${FileHelper.getExtension(profileImage)}";
     // print("profilePicture " + uuid);
     // print("profilePicture " + path);
      var ref = storage.ref().child(path);
      UploadTask task = ref.putFile(profileImage);
      await task.whenComplete(() => null);
      var url = await ref.getDownloadURL();

      cPRBusinessExternalPromotion.pictureURL = url;
      cPRBusinessExternalPromotion.picture = uuid;
    }

    return db
        .collection(FirestorePaths.externalPromotionsCollectionRoot)
        .add(cPRBusinessExternalPromotion.toJSON())
        .then((value) =>
        print("External Promotion Added")
    ).catchError((error) => print("Failed to add External Promotion: $error"));
  }

  Future<List<CPRBusinessExternalPromotion>> getExternalPromotions() async {
    Timestamp timestamp = Timestamp.fromDate(DateTime.now());
    QuerySnapshot querySnapshot = await db
        .collection(FirestorePaths.externalPromotionsCollectionRoot)
        .where("endDate", isGreaterThanOrEqualTo: timestamp)
        .limit(7)
        .get();
    List<CPRBusinessExternalPromotion> _cPRBusinessExternalPromotions = [];

    querySnapshot.docs.forEach((element) {
      _cPRBusinessExternalPromotions.add(CPRBusinessExternalPromotion.fromDocumentSnapshot(element));
    });
    return _cPRBusinessExternalPromotions;
  }

  Future<List<CPRBusinessExternalPromotion>> getExternalAllPromotions() async {
    QuerySnapshot querySnapshot = await db.collection(FirestorePaths.externalPromotionsCollectionRoot).get();
    List<CPRBusinessExternalPromotion> _cPRBusinessExternalPromotions = [];

    querySnapshot.docs.forEach((element) {
      _cPRBusinessExternalPromotions.add(CPRBusinessExternalPromotion.fromDocumentSnapshot(element));
    });
    return _cPRBusinessExternalPromotions;
  }

  Future<List<CPRBusinessExternalPromotion>> getExternalPromotionsOfPlace(String placeId) async {
    QuerySnapshot querySnapshot =
        await db.collection(FirestorePaths.externalPromotionsCollectionRoot).where('placeId', isEqualTo: placeId).get();
    List<CPRBusinessExternalPromotion> _cPRBusinessExternalPromotions = [];

    querySnapshot.docs.forEach((element) {
      _cPRBusinessExternalPromotions.add(CPRBusinessExternalPromotion.fromDocumentSnapshot(element));
    });
    return _cPRBusinessExternalPromotions;
  }

  Future<void> updateExternalPromotion(String docId, CPRBusinessExternalPromotion cPRBusinessExternalPromotion, File? profileImage) async {
    if (profileImage != null) {
      if (cPRBusinessExternalPromotion.pictureURL != null) {
          try {
            var p = storage.refFromURL(cPRBusinessExternalPromotion.pictureURL!);
            await p.delete();
          } catch (e) {
            print(e);
          }
      }
      String uuid = OtherHelper.getUUID().toUpperCase();
      String path = "promotion_images/$uuid${FileHelper.getExtension(profileImage)}";
     // print("profilePicture " + uuid);
     // print("profilePicture " + path);
      var ref = storage.ref().child(path);
      UploadTask task = ref.putFile(profileImage);
      await task.whenComplete(() => null);
      var url = await ref.getDownloadURL();

      cPRBusinessExternalPromotion.pictureURL = url;
      cPRBusinessExternalPromotion.picture = uuid;
    }

    return db
        .collection(FirestorePaths.externalPromotionsCollectionRoot)
        .doc(docId)
        .update(cPRBusinessExternalPromotion.toJSON())
        .then((value) => print("External Promotion Updated"))
        .catchError((error) => print("Failed to Update External Promotion: $error"));
  }

  Future<void> deleteExternalPromotion(String docId, {required String pictureURL}) async {
    if (pictureURL != null) {
      try {
        try {
          var p = storage.refFromURL(pictureURL);
          await p.delete();
        } catch (e) {
          print(e);
        }
      } catch (e) {
        print(e);
      }
    }

    return db
        .collection(FirestorePaths.externalPromotionsCollectionRoot)
        .doc(docId)
        .delete()
        .then((value) => print("External Promotion Deleted"))
        .catchError((error) => print("Failed to Delete External Promotion: $error"));
  }
}
