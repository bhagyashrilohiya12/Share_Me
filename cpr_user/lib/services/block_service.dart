import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/models/blocked_user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BlockService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  Future<CPRBlockedUser?> isBlockedByYou(String yourId, String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await db.collection(FirestorePaths.BlockedUserCollectionRoot).where("blockerId", isEqualTo: yourId).get();
      if (querySnapshot.size > 0) {
        List<CPRBlockedUser> blocks =
            querySnapshot.docs.map((snap) => CPRBlockedUser.fromDocumentSnapshot(snap)).toList();
        try {
          CPRBlockedUser cPRBlockedUser = blocks.firstWhere((element) => element.blockedId == userId);
          return cPRBlockedUser;
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

  Future<CPRBlockedUser?> isBlockedYou(String yourId, String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await db.collection(FirestorePaths.BlockedUserCollectionRoot).where("blockerId", isEqualTo: userId).get();
      if (querySnapshot.size > 0) {
        List<CPRBlockedUser> blocks =
            querySnapshot.docs.map((snap) => CPRBlockedUser.fromDocumentSnapshot(snap)).toList();
        try {
          CPRBlockedUser cPRBlockedUser = blocks.firstWhere((element) => element.blockedId == yourId);
          return cPRBlockedUser;
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

  Future<int> getBlocksCount(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await db.collection(FirestorePaths.BlockedUserCollectionRoot).where("blockerId", isEqualTo: userId).get();
      return querySnapshot.size;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<List<CPRBlockedUser>> getBlocks(String userId) async {
    List<CPRBlockedUser> blocks = [];
    try {
      QuerySnapshot querySnapshot =
          await db.collection(FirestorePaths.BlockedUserCollectionRoot).where("blockerId", isEqualTo: userId).get();
      if (querySnapshot.size > 0) {
        blocks = querySnapshot.docs.map((snap) => CPRBlockedUser.fromDocumentSnapshot(snap)).toList();
      }
    } catch (e) {
      print(e);
    }
    return blocks;
  }
  Future<List<CPRBlockedUser>> getMyBlockers(String userId) async {
    List<CPRBlockedUser> blocks = [];
    try {
      QuerySnapshot querySnapshot =
          await db.collection(FirestorePaths.BlockedUserCollectionRoot).where("blockedId", isEqualTo: userId).get();
      if (querySnapshot.size > 0) {
        blocks = querySnapshot.docs.map((snap) => CPRBlockedUser.fromDocumentSnapshot(snap)).toList();
      }
    } catch (e) {
      print(e);
    }
    return blocks;
  }

  Future<CPRBlockedUser?> block(CPRBlockedUser cprFollowerFollowing) async {
    try {
      await db
          .collection(FirestorePaths.BlockedUserCollectionRoot)
          .doc(cprFollowerFollowing.id)
          .set(cprFollowerFollowing.toJSON());
      var result = await db.collection(FirestorePaths.BlockedUserCollectionRoot).doc(cprFollowerFollowing.id).get();
      return CPRBlockedUser.fromDocumentSnapshot(result);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> unBlock(String? documentID, {  String? blockedEmail}) async {
    try {
      if (blockedEmail != null) {
        var doc = await db
            .collection(FirestorePaths.BlockedUserCollectionRoot)
            .where('blockedId', isEqualTo: blockedEmail)
            .get();
        if (doc != null && doc.docs.length > 0) {
          documentID = doc.docs.first.id;
        }
      }
      await db.collection(FirestorePaths.BlockedUserCollectionRoot).doc(documentID).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
