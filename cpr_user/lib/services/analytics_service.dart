import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/models/analytics.dart';
import 'package:cpr_user/models/follower_following.dart';
import 'package:cpr_user/models/review_like.dart';
import 'package:cpr_user/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AnalyticsService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  Future<Analytics?> addAnalytic(Analytics analytics) async {
    try {
      DocumentReference dr = await db.collection(FirestorePaths.analytics).add(analytics.toJSON());
      var result = await db.collection(FirestorePaths.analytics).doc(dr.id).get();
      return Analytics.fromDocumentSnapshot(result);
    } catch (e) {
      print(e);
      return null;
    }
  }

}