import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/helpers/geo_flutter_fire_utils.dart';
import 'package:cpr_user/helpers/number_helper.dart';
import 'package:cpr_user/interfaces/searchable.dart';
import 'package:geolocator/geolocator.dart';

class Place implements Searchable {
  String? documentId;
  String? name;
  String? parentCategory;
  String? phone;
  String? address;
  String? website;
  GeoPoint? coordinate;
  HashMap<String, dynamic>? location;
  String? displayName;
  String? lastReviewId;
  String? googlePlaceID;
  String? businessOwnerEmail;
  String? businessOwnerDocId;
  String? lastReviewImage;
  var googleRating;
  DateTime? lastReviewDate;
  List<String>? googlePhotoReferences;
  List<String>? categories;
  var totalRating;
  int? totalReviews;



  @override
  String toString() {
    return "Place Model - name: " + name.toString()
        + " ,phone: " + phone.toString() + ", documentId: " + documentId.toString() ;
  }

  Place({
    this.name,
    this.parentCategory,
    this.phone,
    this.address,
    this.website,
    this.coordinate,
    this.location,
    this.displayName,
    this.lastReviewId,
    this.googlePlaceID,
    this.businessOwnerEmail,
    this.businessOwnerDocId,
    this.lastReviewImage,
    this.googleRating,
    this.lastReviewDate,
    this.googlePhotoReferences,
    this.categories,
    this.totalRating,
    this.totalReviews,
  });

  factory Place.fromJSON(Map map) {
    Place place = Place();
    try {
      place = Place(
        lastReviewImage: map["lastReviewImage"] != null ? map["lastReviewImage"] : null,
        displayName: map["displayName"] != null ? map["displayName"] : null,
        address: map["address"] != null ? map["address"] : null,
        lastReviewId: map["lastReviewId"] != null ? map["lastReviewId"] : null,
        googlePlaceID: map["googlePlaceID"] != null ? map["googlePlaceID"] : null,
        businessOwnerEmail: map["businessOwnerEmail"] != null ? map["businessOwnerEmail"] : null,
        businessOwnerDocId: map["businessOwnerDocId"] != null ? map["businessOwnerDocId"] : null,
        name: map["name"] != null ? map["name"] : null,
        parentCategory: map["parentCategory"] != null ? map["parentCategory"] : null,
        phone: map["phone"] != null ? map["phone"] : null,
        website: map["website"] != null ? map["website"] : null,
        googleRating: map["googleRating"] != null ? map["googleRating"] : 0,
        totalRating: map["totalRating"] != null ? map["totalRating"] : 0,
        totalReviews: map["totalReviews"] != null ? map["totalReviews"] : 0,
        googlePhotoReferences:
            map["googlePhotoReferences"] != null ? (map["googlePhotoReferences"] as List).map((f) => f.toString()).toList() : null,
        categories: map["categories"] != null ? (map["categories"] as List).map((f) => f.toString()).toList() : null,
      );
    } catch (e) {
      print("Place Model => " + e.toString());
    }

    try {
      place.lastReviewDate = map["lastReviewDate"] != null ? DateTime.parse(map["lastReviewDate"]) : null;
    } catch (e) {
      try {
        place.lastReviewDate = map["lastReviewDate"] != null ? map["lastReviewDate"].toDate() : null;
      } catch (e) {
        print(e);
      }
    }

    if (map["location"] != null)
      try {
        HashMap<String, dynamic> loc = new HashMap();
        loc['geopoint'] = map["location"]["geopoint"];
        loc['geohash'] = map["location"]["geohash"];
        place.location = loc;
      } catch (e) {
        print("Place Model (location) => " + e.toString());
      }

    try {
      place.coordinate = map["coordinate"] != null ? map["coordinate"] : null;
    } catch (e) {
      try {
        place.coordinate = map["coordinate"] != null ? new GeoPoint(map["coordinate"]['_latitude'], map["coordinate"]['_longitude']) : null;
      } catch (e) {
        print("Place Model (coordinate) => " + e.toString());
      }
    }

    return place;
  }

  factory Place.fromDocumentSnapshot(DocumentSnapshot doc) {

    var myData = doc.data() as Map<String, dynamic>;

    Place place = Place();
    if (myData["place"] != null) {
      place = Place.fromJSON( myData["place"] );
    } else {
      place = Place.fromJSON( myData );
    }
    if (place.location == null) {
      if (place.coordinate != null) {
        try {
          HashMap<String, dynamic> loc = new HashMap();
          loc['geopoint'] = place.coordinate;
          loc['geohash'] = GeoFlutterFireUtils().encode(place.coordinate!.latitude, place.coordinate!.longitude, 9);
          place.location = loc;
        } catch (e) {
          print(e);
        }
      }
    }
    place.documentId = doc.id;
    return place;
  }

  factory Place.fromDocumentSnapshotSaved(DocumentSnapshot doc) {

    var place = Place.fromJSON(doc.data() as Map<String,dynamic>);
    place.documentId = doc.id;
    return place;
  }

  String? get firstGooglePhotoReference {
    if (googlePhotoReferences == null) {
      return '';
    }
    if (googlePhotoReferences!.isEmpty) {
      return '';
    }
    return googlePhotoReferences![0];
  }

  factory Place.fromGooglePlacesResult(Map<String, dynamic> gplace) {
    var place = Place(
      googlePlaceID: gplace["place_id"],
      name: gplace["name"],
      address: gplace["formatted_address"],
      phone: gplace["international_phone_number"],
      website: gplace["website"],
    );
    if (gplace["photos"] != null) {
      var list = gplace["photos"] as List;
      place.googlePhotoReferences = list.map((photo) => photo["photo_reference"].toString()).toList();
    }
    gplace["rating"] != null ? place.googleRating = gplace["rating"].toDouble() : null;

    if (gplace["types"] != null) {
      place.categories = (gplace["types"] as List).map((o) => o.toString()).toList();
      place.parentCategory = place.categories![0];
    }

    try {
      var lat = gplace["geometry"]["location"]["lat"] as double;
      var lng = gplace["geometry"]["location"]["lng"] as double;
      // var loc = Geoflutterfire().point(latitude: lat, longitude: lng).data;
      place.coordinate = GeoPoint(lat, lng);
      // place.location = loc;
    } catch (e) {
      print("Error parsing the location $e");
    }

    return place;
  }

  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "phone": phone,
      "address": address,
      "lastReviewDate": lastReviewDate?.toIso8601String(),
      "lastReviewImage": lastReviewImage,
      "lastReviewId": lastReviewId,
      "website": website,
      "coordinate": coordinate,
      "location": location,
      "displayName": displayName,
      "googlePlaceID": googlePlaceID,
      "businessOwnerEmail": businessOwnerEmail,
      "businessOwnerDocId": businessOwnerDocId,
      "googlePhotoReferences": googlePhotoReferences,
      "googleRating": googleRating,
      "totalReviews": totalReviews,
      "totalRating": totalRating,
      "parentCategory": categories != null && categories!.isNotEmpty ? categories![0] : '',
      "categories": categories ?? []
    };
  }

  Map<String, dynamic> toRatingJSON() => {"totalReviews": totalReviews, "totalRating": totalRating};

  Map<String, dynamic> toSavePlaceJSON() {
    return {"addedOn": DateTime.now(), "place": toJSON()};
  }


  @override
  bool operator ==( o ){
    /**
     * #abdo
     * bool? operator ==(o) => o is Place && o.googlePlaceID == googlePlaceID;
     */
    return o is Place && o.googlePlaceID == googlePlaceID;
  }



    int  hascode(){
      /**
       * #abdo
       *
          // int? get hashCode => googlePlaceID.hashCode;
       */
      return googlePlaceID.hashCode;
    }


  dynamic findLocationByCoordinate(GeoPoint? coor) {
    if (coor != null) {
      try {
        HashMap<String, dynamic> loc = new HashMap();
        loc['geopoint'] = coor;
        loc['geohash'] = GeoFlutterFireUtils().encode(coor.latitude, coor.longitude, 9);
        return loc;
      } catch (e) {
        print(e);
      }
    }
  }

  void generateLocationByCoordinate() {
    if (location == null) {
      location = findLocationByCoordinate(coordinate);
    }
  }

 // @override
  bool  find(String? value, double? startRate, double? endRate, GeoPoint? currentLocation, double? distance) {
    if (value == null) {
      return false;
    }
    double? calDistance =
        Geolocator.distanceBetween(currentLocation!.latitude, currentLocation.longitude,
            coordinate!.latitude, coordinate!.longitude);
    bool? isInDistanceRange = distance != null ? calDistance < distance : true;
    bool? isInRateRange = startRate! <= double.parse(iconTile) && double.parse(iconTile) < endRate!;
    bool? find = isInDistanceRange && isInRateRange && name!.toLowerCase().contains(value.toLowerCase());
    return find;
  }

  @override
  String  get firstTile => name!;

  @override
  String  get iconTile {
    if (googleRating != null) {
      double? realRating = NumberHelper.roundTo(totalRating / totalReviews);
      if (realRating > 5) {
        realRating = 5;
      }
      return realRating.isNaN ? "0" : realRating.toString();
    } else {
      return '';
    }
  }

  @override
  String  get secondTile => address!;

  @override
  String  get thirdTile => '';

}
