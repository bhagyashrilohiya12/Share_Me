import 'package:cloud_firestore/cloud_firestore.dart';

class CPRBusinessReviewReport {
  String? documentID;
  String? description;
  String? email;
  String? reviewId;
  int? reviewReportType;
  String? placeId;
  bool? isBesiness;

  CPRBusinessReviewReport(
      {  this.documentID,
          this.description,
          this.email,
          this.reviewId,
          this.reviewReportType,
          this.placeId,
          this.isBesiness});

  factory CPRBusinessReviewReport.fromJson(Map<String, dynamic> map) {

    var owner = CPRBusinessReviewReport(
      description: map["description"] ?? null,
      email: map["email"] ?? null,
      reviewId: map["reviewId"] ?? null,
      reviewReportType: map["reviewReportType"]!=null?int.parse(map["reviewReportType"]):null,
      placeId: map["placeId"] ?? null,
      isBesiness: map["isBesiness"] ?? null, documentID: '',
    );
    return owner;
  }

  factory CPRBusinessReviewReport.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    var campaign = CPRBusinessReviewReport.fromJson(map);
    campaign.documentID = doc.id;
    return campaign;
  }

  Map<String, dynamic> toJSON() {
    return {
      "description": description,
      "email": email,
      "reviewId": reviewId,
      "reviewReportType": reviewReportType,
      "placeId": placeId,
      "isBesiness": isBesiness,
    };
  }

}
