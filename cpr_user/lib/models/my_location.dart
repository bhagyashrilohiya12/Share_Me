import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/helpers/other_helper.dart';

class CPRMyLocation {
  String? documentID;
  String? id;
  String? title;
  String? userId;
  double? lat;
  double? lon;

  CPRMyLocation({this.documentID, this.id, this.title, this.userId, this.lat, this.lon}) {
    if (id == null) id = OtherHelper.getUUID().toUpperCase();
  }

  factory CPRMyLocation.fromJson(Map<String, dynamic> map) {
    var owner = CPRMyLocation(
      id: map["id"] ?? null,
      title: map["title"] ?? null,
      userId: map["userId"] ?? null,
      lat: map["lat"] ?? null,
      lon: map["lon"] ?? null,
    );
    return owner;
  }

  factory CPRMyLocation.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    var employee = CPRMyLocation.fromJson(map);
    employee.documentID = doc.id;
    return employee;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "title": title,
      "userId": userId,
      "lat": lat,
      "lon": lon,
    };
  }
}
