import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/models/follower_following.dart';
import 'package:cpr_user/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FollowingFollowerService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  Future<CPRFollowerFollowing?> isYourFollowing(String yourId, String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await db.collection(FirestorePaths.followingFollowerCollectionRoot).where("followerId", isEqualTo: yourId).get();
      if (querySnapshot.size > 0) {
        List<CPRFollowerFollowing> follows = querySnapshot.docs.map((snap) => CPRFollowerFollowing.fromDocumentSnapshot(snap)).toList();
        try {
          CPRFollowerFollowing cprFollowerFollowing = follows.firstWhere((element) => element.followingId == userId);
          return cprFollowerFollowing;
        } catch (e) {
          print(e);
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int> getFollowingsCount(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await db.collection(FirestorePaths.followingFollowerCollectionRoot).where("followerId", isEqualTo: userId).get();
      return querySnapshot.size;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<int> getFollowersCount(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await db.collection(FirestorePaths.followingFollowerCollectionRoot).where("followingId", isEqualTo: userId).get();
      return querySnapshot.size;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<List<CPRFollowerFollowing>> getFollowers(String userId) async {
    List<CPRFollowerFollowing> followers = [];
    try {
      QuerySnapshot querySnapshot =
          await db.collection(FirestorePaths.followingFollowerCollectionRoot).where("followingId", isEqualTo: userId).get();
      if (querySnapshot.size > 0) {
        followers = querySnapshot.docs.map((snap) => CPRFollowerFollowing.fromDocumentSnapshot(snap)).toList();
      }
    } catch (e) {
      print(e);
    }
    return followers;
  }

  Future<List<CPRFollowerFollowing>> getFollowings(String userId) async {
    List<CPRFollowerFollowing> followers = [];
    try {
      QuerySnapshot querySnapshot =
          await db.collection(FirestorePaths.followingFollowerCollectionRoot).where("followerId", isEqualTo: userId).get();
      if (querySnapshot.size > 0) {
        followers = querySnapshot.docs.map((snap) => CPRFollowerFollowing.fromDocumentSnapshot(snap)).toList();
      }
    } catch (e) {
      print(e);
    }
    return followers;
  }

  Future<CPRFollowerFollowing?> follow(CPRFollowerFollowing cprFollowerFollowing) async {
    try {
      await db.collection(FirestorePaths.followingFollowerCollectionRoot).doc(cprFollowerFollowing.id).set(cprFollowerFollowing.toJSON());
      var result = await db.collection(FirestorePaths.followingFollowerCollectionRoot).doc(cprFollowerFollowing.id).get();
      return CPRFollowerFollowing.fromDocumentSnapshot(result);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> unFollow(String? documentID, {  String? followingEmail}) async {
    try {
      if(followingEmail!=null){
        var doc = await db.collection(FirestorePaths.followingFollowerCollectionRoot).where('followingId',isEqualTo: followingEmail).get();
        if(doc!=null && doc.docs.length>0){
          documentID = doc.docs.first.id;
        }
      }
      await db.collection(FirestorePaths.followingFollowerCollectionRoot).doc(documentID).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
