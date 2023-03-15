import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/models/business_working_day_hour.dart';
import 'package:cpr_user/models/tag_item.dart';

class CPRBusinessOwner {
  String? placeId;
  String? firstName;
  String? surname;
  String? companyPosition;
  String? companyName;
  String? tradingName;
  String? address;
  String? postcode;
  String? website;
  String? telephoneNumber;
  String? email;
  String? fcmToken;
  String? country;
  List<TagItem>? tags;
  List<String>? internalPictureURLs;
  List<String>? externalPictureURLs;


  String? displayName;
  String? companyDisplayName;
  String? fullName;

  String? documentID;
  CPRBusinessWorkingDayHour? openingHours;

  //String? countryCode;
  //DateTime dateOfBirth;
  //String? gender;
  //bool? isBusiness;
  //String? loginType;
  //String? maritalStatus;
  //String? mobile;
  String? profilePicture;
  String? profilePictureURL;

  //List<Review> reviews;

  //List<AddedPlace> saveForLater;

  //List<AddedPlace> favorites;

  //List<Review> drafts;

  CPRBusinessOwner({
    this.documentID = '',
    this.placeId = '',
    this.firstName = "",
    this.surname = "",
    this.companyPosition = "",
    this.companyName = "",
    this.tradingName = "",
    this.address = "",
    this.postcode = "",
    this.website = "",
    this.telephoneNumber = "",
    this.email = "",
    this.fcmToken = "",
    this.country,
    this.tags,
    this.internalPictureURLs,
    this.externalPictureURLs,
    this.displayName = "",
    this.companyDisplayName = "",
    this.fullName = "",
    this.openingHours,
    this.profilePicture,
    this.profilePictureURL,
    //this.countryCode,
    //this.dateOfBirth,
  });

  String? percentRegistration() {
    var done = [
      firstName,
      surname,
      fullName,
      companyPosition,
      companyName,
      tradingName,
      address,
      postcode,
      website,
      telephoneNumber,
      email,
      fcmToken,
      displayName,
      companyDisplayName,
    ];
    int? counter = 0;
    /**
     * #abdo
        // var sum = done.forEach((i) => counter += i!.isNotEmpty ? 1 : 0);
     */

    return (counter / done.length * 100.0).toStringAsFixed(0);
  }

  factory CPRBusinessOwner.fromJson(Map<String, dynamic> map) {
    List<TagItem> tempTags = [];
    if (map['tags'] != null) {
      tempTags = <TagItem>[];
      map['tags'].forEach((v) {
        tempTags.add(new TagItem.fromJson(v));
      });
    }

    List<String>? tempInternalPictureURLs = [];
    if (map['internalPictureURLs'] != null) {
      tempInternalPictureURLs = <String>[];
      map['internalPictureURLs'].forEach((v) {
        tempInternalPictureURLs!.add(v);
      });
    }
    List<String>? tempExternalPictureURLs = [];
    if (map['externalPictureURLs'] != null) {
      tempExternalPictureURLs =   [];
      map['externalPictureURLs'].forEach((v) {
        tempExternalPictureURLs!.add(v);
      });
    }

    var owner = CPRBusinessOwner(
      placeId: map["placeId"] ?? null,
      firstName: map["firstName"] ?? "",
      surname: map["surname"] ?? "",
      companyPosition: map["companyPosition"] ?? "",
      companyName: map["companyName"] ?? "",
      tradingName: map["tradingName"] ?? "",
      address: map["address"] ?? "",
      postcode: map["postcode"] ?? "",
      website: map["website"] ?? "",
      telephoneNumber: map["telephoneNumber"] ?? "",
      email: map["email"] ?? "",
      fcmToken: map["fcmToken"] ?? "",
      country: map["country"] ?? null,
      displayName: map["displayName"] ?? "",
      companyDisplayName: map["companyDisplayName"] ?? "",
      fullName: map["fullName"] ?? "",
      openingHours: map["openingHours"] != null ? CPRBusinessWorkingDayHour.fromJson(map["openingHours"]) : new CPRBusinessWorkingDayHour(),
      tags: tempTags,
      internalPictureURLs: tempInternalPictureURLs,
      externalPictureURLs: tempExternalPictureURLs,
      //countryCode: map["countryCode"],
      //gender: map["gender"],
      //isBusiness: map["isBusiness"],
      //loginType: map["loginType"],
      //maritalStatus: map["maritalStatus"],
//        mobile: map["mobile"],
      profilePicture: map["profilePicture"] ?? null,
      profilePictureURL: map["profilePictureURL"] ?? null,
    );
    try {
      //owner.dateOfBirth = DateTime.fromMillisecondsSinceEpoch(
      //(map["dateOfBirth"] as Timestamp).millisecondsSinceEpoch);
    } catch (e) {
      print('Could not convert date of birth of ' + map["dateOfBirth"]);
    }

    return owner;
  }

  factory CPRBusinessOwner.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    var owner = CPRBusinessOwner.fromJson(map);
    owner.documentID = doc.id;
    return owner;
  }

  Map<String, dynamic> toJSON() {
    return {
      "placeId": placeId,
      "firstName": firstName,
      "surname": surname,
      "companyPosition": companyPosition,

      "companyName": companyName,
      "tradingName": tradingName,
      "address": address,
      "postcode": postcode,
      "website": website,
      "telephoneNumber": telephoneNumber,
      "email": email,
      "fcmToken": fcmToken,
      "country": country,

      "displayName": displayName,
      "companyDisplayName": companyDisplayName,
      "fullName": fullName,
      "openingHours": openingHours != null ? openingHours!.toJSON() : null,
      "tags": tags != null ? this.tags!.map((v) => v.toJSON()).toList() : null,
      "internalPictureURLs": internalPictureURLs != null ? this.internalPictureURLs!.map((v) => v).toList() : null,
      "externalPictureURLs": externalPictureURLs != null ? this.externalPictureURLs!.map((v) => v).toList() : null,

      //"countryCode": countryCode,
      //"gender": gender,
      //"dateOfBirth": dateOfBirth,
      //"isBusiness": isBusiness,
      //"loginType": loginType,
      //"maritalStatus": maritalStatus,
      //"mobile": mobile,
      "profilePicture": profilePicture,
      "profilePictureURL": profilePictureURL,
    };
  }
}
