import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/models/user.dart';

class Analytics {
  String? documentID;
  String? visitorId;
  String? placeId;
  Timestamp? visitTime;
  int? analyticsType;


  Analytics({required this.documentID, required  this.visitorId,required  this.placeId, required  this.visitTime, required  this.analyticsType});

  factory Analytics.fromJson(Map<String, dynamic> map) {
    var follow = Analytics(
      visitorId: map["visitorId"] ?? null,
      placeId: map["placeId"] ?? null,
      visitTime: map["visitTime"] != null?Timestamp(map["visitTime"]['_seconds'], map["visitTime"]['_nanoseconds']):null,
      analyticsType: map["analyticsType"] ?? null, documentID: '',
    );
    return follow;
  }

  factory Analytics.fromDocumentSnapshot(DocumentSnapshot doc) {
    /**
     * #abdo
     */
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    var follow = Analytics.fromJson(map);
    follow.documentID = doc.id;
    return follow;
  }

  Map<String, dynamic> toJSON() {
    return {
      "visitorId": visitorId,
      "placeId": placeId,
      "visitTime": visitTime,
      "analyticsType": analyticsType,
    };
  }
}
