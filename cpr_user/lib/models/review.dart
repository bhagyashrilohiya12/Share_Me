import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/helpers/date_helper.dart';
import 'package:cpr_user/interfaces/searchable.dart';
import 'package:cpr_user/models/business_internal_promotion.dart';
import 'package:cpr_user/models/business_server.dart';
import 'package:cpr_user/models/place.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:geolocator/geolocator.dart';

class Review implements Searchable {



  /**
   * //-#abdo
      String? get iconTile => rating?.toString? != null? () ?? "0";

      // String  get iconTile => rating!.toString  != null?  "" : "0";
   */
  @override
  String get iconTile  {
    if( rating == null || rating == 0 ) {
      return "0";
    } else {
      return rating.toString();
    }
  }
  //
  //     // @override
  // String  get iconTile {
  //   if (iconTile != null) {
  //     return iconTile.toString();
  //   } else {
  //     return '0';
  //   }
  // }

  //-----------------------------------------------

  String? documentId;
  String? title;
  String? firebaseId;
  List<String>? images;
  List<String>? videos;
  List<String>? downloadURLs;
  List<String>? videoDownloadURLs;
  double? rating;
  double? realRating;
  double? previousRealRating;
  int? waiting;
  DateTime? when;
  DateTime? creationTime;
  dynamic? location;
  String? locationName;
  String? address;
  String? serverName;
  String? serverId;
  String? service;
  String? reasonOfVisit;
  String? companion;
  bool? usePromotion;
  String? comments;
  String? category;
  String? fullReview;
  String? placeID;
  Place? place;
  String? userID;
  String? userUsername;
  String? userDisplayName;
  String? businessReply;
  DateTime? businessReplyDate;
  String? userProfilePictureURL;
  String? businessDisplayName;
  bool? archived;
  bool? businessLiked;
  CPRBusinessServer? server;
  CPRBusinessInternalPromotion? promotion;
  String? promotionDocId;


  Review(
      {this.category,
      this.archived,
      this.businessLiked,
      this.address,
      this.businessDisplayName,
      this.businessReply,
      this.businessReplyDate,
      this.comments,
      this.downloadURLs,
      this.videoDownloadURLs,
      this.companion,
      this.usePromotion,
      this.fullReview,
      this.creationTime,
      this.firebaseId,
      this.images,
      this.videos,
      this.location,
      this.locationName,
      this.place,
      this.placeID,
      this.rating,
      this.reasonOfVisit,
      this.service,
      this.title,
      this.userDisplayName,
      this.userUsername,
      this.userID,
      this.userProfilePictureURL,
      this.waiting,
      this.serverName,
      this.serverId,
      this.server,
      this.promotion,
      this.promotionDocId,
      this.when});

  factory Review.fromJSON(Map<String?, dynamic> map) {
    Review review = Review();
    if(map==null)
      map = new Map<String?, dynamic>();
    try {
      review = Review();
      review.category = map["category"] != null ? map["category"] : null;
      review.archived = map["archived"] != null ? map["archived"] : null;
      review.businessLiked = map["businessLiked"] != null ? map["businessLiked"] : false;
      review.address = map["address"] != null ? map["address"] : null;
      review.businessDisplayName = map["businessDisplayName"] != null ? map["businessDisplayName"] : null;
      review.businessReply = map["businessReply"] != null ? map["businessReply"] : null;
      review.comments = map["comments"] != null ? map["comments"] : null;
      review.companion = map["companion"] != null ? map["companion"] : null;
      review.usePromotion = map["usePromotion"] != null ? map["usePromotion"] : false;
      review.firebaseId = map["firebaseId"] != null ? map["firebaseId"] : null;
      review.location = map["location"] != null ? map["location"] : null;
      review.locationName = map["locationName"] != null ? map["locationName"] : null;
      review.placeID = map["placeID"] != null ? map["placeID"] : null;
      review.reasonOfVisit = map["reasonOfVisit"] != null ? map["reasonOfVisit"] : null;
      review.service = map["service"] != null ? map["service"] : null;
      review.fullReview = map["fullReview"] != null ? map["fullReview"] : null;
      review.title = map["title"] != null ? map["title"] : null;
      review.userDisplayName = map["userDisplayName"] != null ? map["userDisplayName"] : null;
      review.userUsername = map["userUsername"] != null ? map["userUsername"] : null;
      review.userID = map["userID"] != null ? map["userID"] : null;
      review.userProfilePictureURL = map["userProfilePictureURL"] != null ? map["userProfilePictureURL"] : null;
      review.promotionDocId = map["promotionDocId"] != null ? map["promotionDocId"] : null;
      try {
        review.serverName = map["serverName"] != null ? map["serverName"] : null;
        review.serverId = map["serverId"] != null ? map["serverId"] : null;
        review.server = map["server"] != null ? CPRBusinessServer.fromJson(map["server"]) : null;
        review.promotion = map["promotion"] != null ? CPRBusinessInternalPromotion.fromJson(map["promotion"]) : null;
      } catch (e) {
        print(e);
      }

      //rate
      try {
        double rating = map[ "rating"];
        // String rating = map["rating"];
      //  Log.i("Review Model - rating  $rating");
        review.rating = rating ;
      } catch (e) {
        Log.i("Review Model - (rate) =>  error $e");
      }
     // Log.i("Review Model - map.rating " + map["rating"].toString() );
    //  Log.i("Review Model - (rate) =>  print " + review.rating.toString() );

      try {
        if (map["realRating"] != null) {
          var realRating = map["realRating"]  ;

          // != null?();
          review.realRating =  realRating ;
        }
      } catch (e) {
        print("Review Model (realRating) => " + "error $e");
      }
      review.previousRealRating = review.realRating;
      try {
        if (map["waiting"] != null) {
          var waiting = map["waiting"].toString();
          review.waiting = int.parse(waiting);
        }
      } catch (e) {
        print("Review Model (waiting) => " + "error $e");
//        print("Waiting time error: $e ");
      }

      try {
        if (map["when"] != null) review.when = DateTime.fromMicrosecondsSinceEpoch((map["when"] as Timestamp).microsecondsSinceEpoch);
      } catch (e) {
        try {
          review.when = DateTime.fromMicrosecondsSinceEpoch((map["when"]).microsecondsSinceEpoch);
        } catch (e) {
          print("Review Model (when) => " + "error $e");
        }
      }
      try {
        if (map["creationTime"] != null)
          review.creationTime = DateTime.fromMicrosecondsSinceEpoch((map["creationTime"] as Timestamp).microsecondsSinceEpoch);
      } catch (e) {
        review.creationTime = Timestamp(map["creationTime"]['_seconds'], map["creationTime"]['_nanoseconds']).toDate();
        print("Review Model (creationTime) => " + "error $e");
      }
      try {
        if (map["businessReplyDate"] != null)
          review.businessReplyDate = DateTime.fromMicrosecondsSinceEpoch((map["businessReplyDate"] as Timestamp).microsecondsSinceEpoch);
      } catch (e) {
        print("Review Model (businessReplyDate) => " + "error $e");
      }
      try {
        if (map["images"] != null) review.images = (map["images"] as List).map((f) => f.toString()).toList();
      } catch (e) {
        print("Review Model (images) => " + "error $e");
      }
      try {
        if (map["videos"] != null) review.videos = (map["videos"] as List).map((f) => f.toString()).toList();
      } catch (e) {
        print("Review Model (videos) => " + "error $e");
      }
      try {
        if (map["downloadURLs"] != null) review.downloadURLs = (map["downloadURLs"] as List).map((f) => f.toString()).toList();
      } catch (e) {
        print("Review Model (downloadURLs) => " + "error $e");
      }
      try {
        if (map["videoDownloadURLs"] != null)
          review.videoDownloadURLs = (map["videoDownloadURLs"] as List).map((f) => f.toString()).toList();
      } catch (e) {
        print("Review Model (videoDownloadURLs) => " + "error $e");
      }
      try {
        if (map["place"] != null) review.place = Place.fromJSON(map["place"]);
      } catch (e) {
        print("Review Model (place) => " + "error $e");
      }
    } catch (e) {
      print("Review Model => " + "error $e");
    }
    return review;
  }

  factory Review.fromDocumentSnapshot(DocumentSnapshot f) {
    var review = Review.fromJSON(f.data() as Map<String, dynamic>);
    try {
      review.documentId = f.id;
    } catch (e) {
      print(e);
    }
    return review;
  }

  Map<String, dynamic> toJSON() {
    return {
      "address": address,
      "archived": archived,
      "businessLiked": businessLiked,
      "businessDisplayName": businessDisplayName,
      "businessReply": businessReply,
      "businessReplyDate": businessReplyDate,
      "category": category,
      "comments": comments,
      "companion": companion,
      "usePromotion": usePromotion,
      "creationTime": creationTime,
      "downloadURLs": downloadURLs,
      "videoDownloadURLs": videoDownloadURLs,
      "firebaseId": firebaseId,
      "images": images,
      "videos": videos,
      "location": location,
      "locationName": locationName,
      "place": place?.toJSON(),
      "placeID": placeID,
      "rating": rating,
      "realRating": realRating,
      "previousRealRating": previousRealRating,
      "reasonOfVisit": reasonOfVisit,
      "server": server!=null?server!.toJSON():null,
      "serverName": serverName,
      "serverId": serverId,
      "service": service,
      "fullReview": fullReview,
      "title": title,
      "userDisplayName": userDisplayName,
      "userUsername": userUsername,
      "userID": userID,
      "userProfilePictureURL": userProfilePictureURL,
      "waiting": waiting,
      "promotionDocId": promotionDocId,
      // "server": server != null ? server.toJSON() : null,
      // "promotion": promotion != null ? promotion.toJSON() : null,
      "when": when
    };
  }

  // @override
  bool  find(String? value, double? startRate, double? endRate, GeoPoint? currentLocation, double? distance) {
    if (value == null) {
      return false;
    }

    if( this.place == null   ) return false;

    double? calDistance = Geolocator.distanceBetween(
        currentLocation!.latitude, currentLocation.longitude, place!.coordinate!.latitude, place!.coordinate!.latitude);
    bool? isInDistanceRange = distance != null ? calDistance < distance : true;
    bool? isInRateRange = rating != null && rating! >= startRate!   && rating! < endRate!;
    return isInDistanceRange && isInRateRange && (place?.name ?? "").toLowerCase().contains(value.toLowerCase());
  }


  @override
  String get secondTile {
    if( creationTime != null ) {
      return DateHelper.defaultFormat(creationTime! );
    }
    return "";
  }
  // String  get secondTile  => DateHelper.defaultFormat(creationTime!??"");

  @override
  String  get thirdTile {
    if( comments == null ) return "";
    if( comments!.length <= 30 ) return comments!;
    return comments!.substring(0, 30);
    //comments?.length > 30 ? comments.subString?(0, 30) + "..." : comments ?? '';
    return "";
  }

  @override
  String  get firstTile => place?.name ?? '';

  // @override
  // String  toString() {
  //   return "Review : realRating: " + realRating.toString() + " /rating: " + rating.toString() + " / firstTile: " + firstTile.toString()  ;
  //   // return 'Review{documentId: $documentId, title: $title, firebaseId: $firebaseId, images: $images, videos: $videos, downloadURLs: $downloadURLs,videoDownloadURLs: $videoDownloadURLs, rating: $rating, waiting: $waiting, when: $when, creationTime: $creationTime, location: $location, locationName: $locationName, address: $address, server: $serverName, service: $service, reasonOfVisit: $reasonOfVisit, companion: $companion, comments: $comments, category: $category, fullReview: $fullReview, placeID: $placeID, place: $place, userID: $userID, userDisplayName: $userDisplayName, businessReply: $businessReply, businessReplyDate: $businessReplyDate, userProfilePictureURL: $userProfilePictureURL, businessDisplayName: $businessDisplayName, archived: $archived}';
  // }

  @override
  String toString() {
    return 'Review{ locationName(place.name) $locationName,  title:     $firstTile , rating: $rating, realRating: $realRating, previousRealRating: $previousRealRating, iconTile $iconTile}';
  }


}
