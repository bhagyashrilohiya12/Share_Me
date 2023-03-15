import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/models/business_owner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BusinessOwnerService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  Future<CPRBusinessOwner?> findOwner(String placeId) async {
    try {
      CPRBusinessOwner owner = CPRBusinessOwner();
      try {
        var results = await db.collection(FirestorePaths.businessOwnersCollectionRoot).where("placeId",isEqualTo: placeId).get();
        owner = CPRBusinessOwner.fromDocumentSnapshot(results.docs.first);
      } catch (e) {
        print("User does not exist: $e");
      }
      return owner;
    } catch (e) {}

    return null;
  }

}
