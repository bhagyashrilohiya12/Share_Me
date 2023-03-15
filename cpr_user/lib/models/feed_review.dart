import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/models/business_server.dart';
import 'package:cpr_user/models/review_like.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/models/place.dart';

class FeedReview {
  int? waiting;
  DateTime? when;
  String? fullReview;
  String? comments;
  String? firebaseId;
  String? category;
  List<String>? images;
  CPRBusinessServer? server;
  String? serverName;
  String? serverId;
  String? businessReply;
  String? address;
  String? placeID;
  List<String>? downloadURLs;
  String? userID;
  String? locationName;
  double? realRating;
  String? reasonOfVisit;
  int? rating;
  String? businessDisplayName;
  String? userProfilePictureURL;
  String? title;
  DateTime? creationTime;
  When? creationTimeLocal;
  String? companion;
  String? userDisplayName;
  bool? archived;
  dynamic? location;
  String? service;
  Place? place;
  CPRUser? user;
  List<CPRReviewLike>? likes;
  bool? showLikeProgress = false; // local use

  // FeedReview(
  //     {this.waiting,
  //     this.when,
  //     this.fullReview,
  //     this.comments,
  //     this.firebaseId,
  //     this.category,
  //     this.images,
  //     this.serverName,
  //     this.serverId,
  //     this.server,
  //     this.businessReply,
  //     this.address,
  //     this.placeID,
  //     this.downloadURLs,
  //     this.userID,
  //     this.locationName,
  //     this.realRating,
  //     this.reasonOfVisit,
  //     this.rating,
  //     this.businessDisplayName,
  //     this.userProfilePictureURL,
  //     this.title,
  //     this.creationTime,
  //     this.companion,
  //     this.userDisplayName,
  //     this.archived,
  //     this.location,
  //     this.service,
  //     this.place,
  //     this.user,
  //     this.likes});

  FeedReview.fromJson(Map<String, dynamic> json) {
    user = (json['user'] != null ? new CPRUser.fromJson(json['user']) : null)!;
    waiting = json['waiting'];
    try {
      when = DateTime.fromMicrosecondsSinceEpoch(
          int.parse((json["when"]["_seconds"].toString() + (json["when"]["_nanoseconds"] ~/ 1000).toString())));
    } catch (e) {
      print(e);
    }
    fullReview = json['fullReview'];
    comments = json['comments'];
    firebaseId = json['firebaseId'];
    category = json['category'];
    images = json['images']!=null?json['images'].cast<String>():[];
    try {
      serverName = json["serverName"] != null ? json["serverName"] : null;
      serverId = json["serverId"] != null ? json["serverId"] : null;
      server = json["server"] != null ? CPRBusinessServer.fromJson(json["server"]) : null;
    } catch (e) {
      print(e);
    }
    businessReply = json['businessReply'];
    address = json['address'];
    placeID = json['placeID'];
    try {
      downloadURLs = json['downloadURLs'].cast<String>();
    } catch (e) {
      print(e);
    }
    userID = json['userID'];
    locationName = json['locationName'];
    realRating = json['realRating'];
    reasonOfVisit = json['reasonOfVisit'];
    rating = json['rating'];
    businessDisplayName = json['businessDisplayName'];
    userProfilePictureURL = json['userProfilePictureURL'];
    title = json['title'];
    try {
      creationTime = DateTime.fromMicrosecondsSinceEpoch(
          int.parse((json["creationTime"]["_seconds"].toString() + (json["creationTime"]["_nanoseconds"] ~/ 1000).toString())));
    } catch (e) {
      print(e);
    }
    creationTimeLocal = json['creationTime'] != null ? new When.fromJson(json['creationTime']) : null;
    companion = json['companion'];
    userDisplayName = json['userDisplayName'];
    archived = json['archived'];
    location = json["location"] != null ? json["location"] : null;
    service = json['service'];
    place = json['place'] != null ? new Place.fromJSON(json['place']) : null;
    if (json['likes'] != null) {
      likes = [];
      json['likes'].forEach((v) {
        likes!.add(new CPRReviewLike.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['waiting'] = this.waiting;
    if (this.when != null) {
      data['when'] = this.when;
    }
    data['fullReview'] = this.fullReview;
    data['comments'] = this.comments;
    data['firebaseId'] = this.firebaseId;
    data['category'] = this.category;
    data['images'] = this.images;
    data['server'] = this.server;
    data['serverName'] = this.serverName;
    data['serverId'] = this.serverId;
    data['businessReply'] = this.businessReply;
    data['address'] = this.address;
    data['placeID'] = this.placeID;
    data['downloadURLs'] = this.downloadURLs;
    data['userID'] = this.userID;
    data['locationName'] = this.locationName;
    data['realRating'] = this.realRating;
    data['reasonOfVisit'] = this.reasonOfVisit;
    data['rating'] = this.rating;
    data['businessDisplayName'] = this.businessDisplayName;
    data['userProfilePictureURL'] = this.userProfilePictureURL;
    data['title'] = this.title;
    if (this.creationTime != null) {
      data['creationTime'] = this.creationTime;
    }
    data['companion'] = this.companion;
    data['userDisplayName'] = this.userDisplayName;
    data['archived'] = this.archived;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['service'] = this.service;


    try {
      /**
       * #abdo
          if (this.place  != null) {
          data['place'] = this.place.toJSON();
          }
       */
      data['place'] = this.place!.toJSON();
    } catch ( e) {
    }

    if (this.user != null) {
      data['user'] = this.user!.toJSON();
    }
    if (this.likes != null) {
      data['likes'] = this.likes!.map((v) => v.toJSON()).toList();
    }
    return data;
  }
}

class When {
  int? iSeconds;
  int? iNanoseconds;

  When({this.iSeconds, this.iNanoseconds});

  When.fromJson(Map<String, dynamic> json) {
    iSeconds = json['_seconds'];
    iNanoseconds = json['_nanoseconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_seconds'] = this.iSeconds;
    data['_nanoseconds'] = this.iNanoseconds;
    return data;
  }
}
