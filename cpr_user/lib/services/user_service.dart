import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/helpers/file_helper.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import "package:cpr_user/helpers/string_helper.dart";
import 'package:cpr_user/models/added_place.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/user.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';

class UserService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>> findInformation(userId) async {
    try {
      var myReviewsResults = await db.collection(FirestorePaths.reviewCollectionRoot).where("userID",isEqualTo: userId)
          .where("archived", isEqualTo: false).get();
      var sflResults = await db.collection(FirestorePaths.usersCollectionRoot).doc(userId).collection(FirestorePaths.usersSaveForLaterPlaces).get();
      var favoritesResults = await db.collection(FirestorePaths.usersCollectionRoot).doc(userId).collection(FirestorePaths.usersFavoritesPlaces).get();
      var draftResults = await db.collection(FirestorePaths.usersCollectionRoot).doc(userId).collection(FirestorePaths.usersDraftReviews).get();

      List<Review> reviews = myReviewsResults.docs.map((review) => Review.fromJSON(review.data())).toList();

      List<AddedPlace> sfl = sflResults.docs.map((review) => AddedPlace.fromSnapshot(review)).toList();

      List<AddedPlace> favorites = favoritesResults.docs.map((place) => AddedPlace.fromSnapshot(place)).toList();
      List<Review> draft = draftResults.docs.map((review) => Review.fromJSON(review.data())).toList();
      return {"reviews": reviews, "sfl": sfl, "favorites": favorites, "draft": draft};
    } catch (e) {}
    return {};
  }

  Future<CPRUser?> findUser(String userId, User firebaseUser) async {
    try {
      CPRUser user = CPRUser();
      try {
        var results = await db.collection(FirestorePaths.usersCollectionRoot).doc(userId).get();
        user = CPRUser.fromDocumentSnapshot(results);
      } catch (e) {
        try {
          print("Creating user");
          return await addUser(firebaseUser);
        } catch (e) {
          print("Unable to create this user $e");
        }
        print("User does not exist: $e");
      }
      return user;
    } catch (e) {}

    return null;
  }

  Future<CPRUser?> addUser(User user) async {
    String? email = user.email;
    if (email == null) {
      email = user.providerData[0].email;
    }
    if (user != null) {
      CPRUser userToBeCreated = CPRUser(email: email, displayName: user.displayName, profilePictureURL: user.photoURL);
      try {
        var values = user.displayName!.split(" ");
        userToBeCreated.firstName = values[0];
        userToBeCreated.surname = values[1];
        userToBeCreated.fullName = user.displayName;
      } catch (e) {}

      await db.collection(FirestorePaths.usersCollectionRoot).doc(email).set(userToBeCreated.toJSON());
      try {
        var snapshot = await db.collection(FirestorePaths.usersCollectionRoot).doc(email).get();
        return CPRUser.fromDocumentSnapshot(snapshot);
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<Place?> addToCategory(CPRUser user, Place place, MainCategory category) async {
    String path;
    switch (category) {
      case MainCategory.myFavoritePlaces:
        path = FirestorePaths.usersFavoritesPlaces;
        break;
      case MainCategory.saveForLaterPlaces:
        path = FirestorePaths.usersSaveForLaterPlaces;
        break;
      default:
        return null;
    }

    try {
      await db.collection(FirestorePaths.usersCollectionRoot).doc(user.documentID).collection(path).doc(place.googlePlaceID).set(place.toSavePlaceJSON());
      return place;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<CPRUser> updateUser(CPRUser user, {  File? profilePicture}) async {
    if (profilePicture != null) {
     // Log.i( "updateUser() - profilePicture: " + profilePicture.path );

      //remove old url picture if found
      try {
        if (user.profilePictureURL != null) {
          var p = storage.refFromURL(user.profilePictureURL!);
          await p.delete();
        }
      } catch (e) {
        Log.i( "updateUser() - remove old url picture if found - catch e: " + e.toString() );
      }
    }

    //upload new image
    if (profilePicture != null) {
      try {
        String uuid = OtherHelper.getUUID().toUpperCase();
        String cloud_path = "profile_images/$uuid${FileHelper.getExtension(profilePicture)}";
        Log.i( "updateUser() - cloud_path: " + cloud_path );
        var ref = storage.ref().child(cloud_path);
        UploadTask task = ref.putFile(profilePicture );
        await task.whenComplete(() => null);
        var url = await ref.getDownloadURL();
        Log.i( "updateUser() - getDownloadURL - url: " + url );
        user.profilePictureURL = url;
        user.profilePicture = uuid;
      } catch (e) {
        Log.i( "updateUser() - upload new image - catch e: " + e.toString() );
      }
    }


    //update database
    try {
      await db.collection(FirestorePaths.usersCollectionRoot).doc(user.documentID).update(user.toJSON());
      Log.i( "updateUser() - update database - user: " + user.toString() );
    } catch (e) {}

    DocumentSnapshot doc = await db.collection(FirestorePaths.usersCollectionRoot).doc(user.documentID).get();
    return CPRUser.fromDocumentSnapshot(doc);
  }

  Future<Place?> removeFromCategory(CPRUser user, Place place, MainCategory category) async {
    String path;
    switch (category) {
      case MainCategory.myFavoritePlaces:
        path = FirestorePaths.usersFavoritesPlaces;
        break;
      case MainCategory.saveForLaterPlaces:
        path = FirestorePaths.usersSaveForLaterPlaces;
        break;
      default:
        return null;
    }
    try {
      await db.collection(FirestorePaths.usersCollectionRoot).doc(user.documentID).collection(path).doc(place.googlePlaceID).delete();
      return place;
    } catch (e) {}
    return null;
  }

  Future<List<CPRUser>> searchUsersByUsername(String text,String email) async {
    try {
      QuerySnapshot querySnapshot1 = await db.collection(FirestorePaths.usersCollectionRoot).where("username", isGreaterThanOrEqualTo: text).get();
      List<CPRUser> usersTemp = [];
      querySnapshot1.docs.forEach((element) {
        usersTemp.add(CPRUser.fromDocumentSnapshot(element));
      });
      List<CPRUser> users = [];
      for (int i = 0; i < usersTemp.length; i++) {
        if (usersTemp[i].username!.contains(text)) users.add(usersTemp[i]);
      }
      return users.where((element) => element.email!=email).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<List<CPRUser>> searchUsersByIdsList(List<String?> ids,String email) async {
    try {
      QuerySnapshot querySnapshot1 = await db.collection(FirestorePaths.usersCollectionRoot).where("email", whereIn: ids).get();
      List<CPRUser> usersTemp = [];
      querySnapshot1.docs.forEach((element) {
        usersTemp.add(CPRUser.fromDocumentSnapshot(element));
      });
      return usersTemp.where((element) => element.email!=email).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<CPRUser>> searchUsersByEmail(String text) async {
    try {
      String textCap = text.capitalize();
      QuerySnapshot querySnapshot1 = await db.collection(FirestorePaths.usersCollectionRoot).where("email", isGreaterThanOrEqualTo: text).get();
      List<CPRUser> usersTemp = [];
      querySnapshot1.docs.forEach((element) {
        usersTemp.add(CPRUser.fromDocumentSnapshot(element));
      });
      List<CPRUser> users = [];
      for (int i = 0; i < usersTemp.length; i++) {
        if (usersTemp[i].email!.contains(text) || usersTemp[i].email!.contains(textCap)) users.add(usersTemp[i]);
      }
      return users;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<CPRUser?> getUserById(String userId) async {
    CPRUser user = CPRUser();
    try {
      var results = await db.collection(FirestorePaths.usersCollectionRoot).doc(userId).get();
      user = CPRUser.fromDocumentSnapshot(results);
    } catch (e) {
      print(e);
    }
    return user;
  }


  Future<bool> isUsernameFree(String username,{  String? userEmail}) async {
    try {
      QuerySnapshot querySnapshot = await db.collection(FirestorePaths.usersCollectionRoot).where("username",isEqualTo: username).get();

      Log.i( "isUsernameFree() - querySnapshot: " + querySnapshot.docs.toString() );

      if(querySnapshot.docs.length>0) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        String firstValue = data['email'] ?? "";
        if (userEmail != null && firstValue == userEmail) {
          return true;
        } else {
          return false;
        }
      } else {
        /**
         * no data found for this name
         */
        return true;
      }

      return false;

    } catch ( e) {
      print(e);
      return false;
    }
  }


}
