import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/models/added_place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/user_setting.dart';

class CPRUser {
  String? documentID;
  String? companyDisplayName;
  String? companyPosition;
  String? countryCode;
  DateTime? dateOfBirth;
  String? displayName;
  String? email;
  String? username;
  String? firstName;
  String? fullName;
  bool? isBusiness;
  String? loginType;
  String? maritalStatus;
  String? mobile;
  String? profilePicture;
  String? surname;
  String? profilePictureURL;
  String? zipCode;
  String? fcmToken;
  int? gender;
  int? religion;
  int? followingCount;
  int? followerCount;
  bool? isFollowingByYou = false; //Local use in search screen
  bool? isBlockedByYou = false; //Local use in search screen
  bool? isBlockedYou = false; //Local use in search screen
  bool? followUnfollowProgress = false; //Local use in search screen
  bool? blockUnBlockProgress = false; //Local use in search screen

  List<Review>? reviews;

  List<AddedPlace>? saveForLater;

  List<AddedPlace>? favorites;

  List<Review>? drafts;
  UserSetting? setting;

  CPRUser(
      {
        this.username,
        this.firstName,
      this.email,
      this.fullName,
      this.profilePictureURL,
      this.zipCode,
      this.fcmToken,
      this.companyDisplayName,
      this.companyPosition,
      this.countryCode,
      this.dateOfBirth,
      this.displayName,
      this.gender,
      this.religion,
      this.followingCount,
      this.followerCount,
      this.isBusiness,
      this.loginType,
      this.maritalStatus,
      this.mobile,
      this.profilePicture,
      this.reviews,
      this.favorites,
      this.saveForLater,
      this.surname,
      this.setting});

  factory CPRUser.fromJson(Map<String, dynamic> map) {
    var user = CPRUser(
      surname: map["surname"],
      username: map["username"],
      firstName: map["firstName"],
      fullName: map["fullName"],
      zipCode: map["zipCode"],
      companyDisplayName: map["companyDisplayName"],
      companyPosition: map["companyPosition"],
      countryCode: map["countryCode"],
      displayName: map["displayName"],
      email: map["email"] ?? "",
      gender: map["gender"],
      religion: map["religion"],
      followingCount: map["followingCount"],
      followerCount: map["followerCount"],
      isBusiness: map["isBusiness"],
      loginType: map["loginType"],
      maritalStatus: map["maritalStatus"],
      mobile: map["mobile"],
      profilePicture: map["profilePicture"],
      profilePictureURL: map["profilePictureURL"],
      fcmToken: map["fcmToken"],
      setting: map["setting"]!=null?UserSetting.fromJson(map["setting"]):null,
    );
    try {
      user.dateOfBirth = DateTime.fromMillisecondsSinceEpoch(
          (map["dateOfBirth"] as Timestamp).millisecondsSinceEpoch);
    } catch (e) {
      print("Place Model (dateOfBirth) => " + e.toString());
    }

    return user;
  }

  factory CPRUser.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    var user = CPRUser.fromJson(map);
    user.documentID = doc.id;
    return user;
  }

  Map<String, dynamic> toJSON() {
    return {
      "email": email,
      "displayName": displayName,
      "gender": gender,
      "religion": religion,
      "followingCount": followingCount,
      "followerCount": followerCount,
      "companyDisplayName": companyDisplayName,
      "companyPosition": companyPosition,
      "countryCode": countryCode,
      "dateOfBirth": dateOfBirth,
      "displayName": displayName,
      "fullName": fullName,
      "username": username,
      "firstName": firstName,
      "isBusiness": isBusiness,
      "loginType": loginType,
      "maritalStatus": maritalStatus,
      "mobile": mobile,
      "profilePicture": profilePicture,
      "surname": surname,
      "profilePictureURL": profilePictureURL,
      "zipCode": zipCode,
      "fcmToken": fcmToken,
      // "setting": setting!=null?setting.toJSON():null,
    };
  }
}
