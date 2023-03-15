import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/helpers/file_helper.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/models/business_internal_promotion.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BusinessInternalPromotionsService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  Future<void> addInternalPromotions(
      CPRBusinessInternalPromotion cPRBusinessInternalPromotion, File profileImage) async {
    if (profileImage != null) {
      String uuid = OtherHelper.getUUID().toUpperCase();
      String path = "promotion_images/$uuid${FileHelper.getExtension(profileImage)}";
    //  print("profilePicture " + uuid);
    //  print("profilePicture " + path);
      var ref = storage.ref().child(path);
      UploadTask task = ref.putFile(profileImage);
      await task.whenComplete(() => null);
      var url = await ref.getDownloadURL();

      cPRBusinessInternalPromotion.pictureURL = url;
      cPRBusinessInternalPromotion.picture = uuid;
    }

    return db
        .collection(FirestorePaths.internalPromotionsCollectionRoot)
        .add(cPRBusinessInternalPromotion.toJSON())
        .then((value) => print("Internal Promotion Added"))
        .catchError((error) => print("Failed to add Internal Promotion: $error"));
  }

  Future<List<CPRBusinessInternalPromotion>> getInternalPromotions() async {
    QuerySnapshot querySnapshot = await db.collection(FirestorePaths.internalPromotionsCollectionRoot).get();
    List<CPRBusinessInternalPromotion> _cPRBusinessInternalPromotions = [];

    querySnapshot.docs.forEach((element) {
      _cPRBusinessInternalPromotions.add(CPRBusinessInternalPromotion.fromDocumentSnapshot(element));
    });
    return _cPRBusinessInternalPromotions;
  }

  Future<List<CPRBusinessInternalPromotion>> getInternalPromotionsFromIdsList(List<String> ids) async {
    try {
    List<CPRBusinessInternalPromotion> _cPRBusinessInternalPromotions = [];

    if(ids.length!=0){
      QuerySnapshot querySnapshot =
      await db.collection(FirestorePaths.internalPromotionsCollectionRoot).where('id', whereIn: ids).get();

      querySnapshot.docs.forEach((element) {
        _cPRBusinessInternalPromotions.add(CPRBusinessInternalPromotion.fromDocumentSnapshot(element));
      });

    }
    return _cPRBusinessInternalPromotions;

   } catch (e) {
     return [];
   }
  }

  Future<List<CPRBusinessInternalPromotion>> getInternalPromotionsOfPlace(String placeId) async {
    QuerySnapshot querySnapshot =
        await db.collection(FirestorePaths.internalPromotionsCollectionRoot).where('placeId', isEqualTo: placeId).get();
    List<CPRBusinessInternalPromotion> _cPRBusinessInternalPromotions = [];

    querySnapshot.docs.forEach((element) {
      _cPRBusinessInternalPromotions.add(CPRBusinessInternalPromotion.fromDocumentSnapshot(element));
    });
    return _cPRBusinessInternalPromotions;
  }

  Future<void> updateInternalPromotion(
      String docId, CPRBusinessInternalPromotion cPRBusinessInternalPromotion, File profileImage) async {
    if (profileImage != null) {
      if (cPRBusinessInternalPromotion.pictureURL != null) {
        try {
          try {
            var p = storage.refFromURL(cPRBusinessInternalPromotion.pictureURL!);
            await p.delete();
          } catch (e) {
            print(e);
          }
        } catch (e) {
          print(e);
        }
      }
      String uuid = OtherHelper.getUUID().toUpperCase();
      String path = "promotion_images/$uuid${FileHelper.getExtension(profileImage)}";
     // print("profilePicture " + uuid);
    //  print("profilePicture " + path);
      var ref = storage.ref().child(path);
      UploadTask task = ref.putFile(profileImage);
      await task.whenComplete(() => null);
      var url = await ref.getDownloadURL();

      cPRBusinessInternalPromotion.pictureURL = url;
      cPRBusinessInternalPromotion.picture = uuid;
    }

    return db
        .collection(FirestorePaths.internalPromotionsCollectionRoot)
        .doc(docId)
        .update(cPRBusinessInternalPromotion.toJSON())
        .then((value) => print("Internal Promotion Updated"))
        .catchError((error) => print("Failed to Update Internal Promotion: $error"));
  }

  Future<void> deleteInternalPromotion(String docId, {required String pictureURL}) async {
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
        .collection(FirestorePaths.internalPromotionsCollectionRoot)
        .doc(docId)
        .delete()
        .then((value) => print("Internal Promotion Deleted"))
        .catchError((error) => print("Failed to Delete Internal Promotion: $error"));
  }
}
