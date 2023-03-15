import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/constants/review_sorting.dart';
import 'package:cpr_user/helpers/file_helper.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/models/my_location.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyLocationsService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  Future<List<CPRMyLocation>> getUserReviewsList(CPRUser user) async {
    List<CPRMyLocation> list = [];
    try {
      var docs = await db.collection(FirestorePaths.userLocations).where("userId", isEqualTo: user.email).get();

      list = docs.docs.map((snap) => CPRMyLocation.fromDocumentSnapshot(snap)).toList();
    } catch (e) {
      print(e);
    }

    return list;
  }

  Future<CPRMyLocation?> addNewLocationForUser(CPRMyLocation location) async {
    try {
      await db.collection(FirestorePaths.userLocations).doc(location.id).set(location.toJSON());
      var result = await db.collection(FirestorePaths.userLocations).doc(location.id).get();
      return CPRMyLocation.fromDocumentSnapshot(result);

    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<CPRMyLocation?> editNewLocationForUser(CPRMyLocation location) async {
    try {
      await db.collection(FirestorePaths.userLocations).doc(location.id).set(location.toJSON());
      var result = await db.collection(FirestorePaths.userLocations).doc(location.id).get();
      return CPRMyLocation.fromDocumentSnapshot(result);

    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> deleteMyLocation(String documentID) async {
    try {
      await db.collection(FirestorePaths.userLocations).doc(documentID).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
