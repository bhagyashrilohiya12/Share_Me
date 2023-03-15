import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/helpers/social_profile_helper.dart';
import 'package:cpr_user/models/social_profile.dart';

class SocialProfileService {
  var db = FirebaseFirestore.instance;

//// Get profile key from firebase based on email id
  Future<String?> getProfileKey(String user) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Profiles') //FirestorePaths.socialprofile)
        .doc(user);
    String? profileKey = 'default';
    await documentReference.get().then((snapshot) {
      if (snapshot.exists) {
        profileKey = snapshot['profileKey'].toString();
      } else {
        profileKey = '';
      }
    });
    return profileKey;
  }

  //// Store social profile in firebase
  Future<SocialProfile?> createSocialProfile(
      String user, dynamic profile) async {
    await db.collection('Profiles').doc(user).set(profile);
    return profile;
  }

  Future<SocialProfile?> addSocialAccountStatus(
      String user, String? socialaccountname, String loginstatus) async {
    await db
        .collection('userLoginedSocial')
        .doc(socialaccountname)
        .collection('loginedUsersInfo')
        .doc(user)
        .set({'status': loginstatus});
  }

  Future<SocialProfile?> updateSocialAccountStatus(
      String user, String? socialaccountname, String loginstatus) async {
    await db
        .collection('userLoginedSocial')
        .doc(socialaccountname)
        .collection('loginedUsersInfo')
        .doc(user)
        .update({'status': loginstatus});
  }

  Future<List?> getActiveSocialAccount(String user) async {
    var output = await SocialProfileHelper().getUserProfile(user);
    var outputresponse = jsonDecode(output.body);
    var profiles = outputresponse['profiles'];
    List activeSocialAccounts = profiles[0]['activeSocialAccounts'];
    return activeSocialAccounts;
  }

  Future<int> getConnectedSocialsCount(String? user) async {
    int socialCount = 0;
    List? activeSocialAccounts = await getActiveSocialAccount(user!);
    if (activeSocialAccounts!.isNotEmpty) {
      socialCount = activeSocialAccounts.length;
    }
    return socialCount;
  }
}
