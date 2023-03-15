import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/helpers/other_helper.dart';

class CPRBusinessExternalPromotion {
  String? documentID;
  String? id;
  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  double? discount;
  String? picture;
  String? pictureURL;
  String? placeId;
  String? ownerEmail;
  int? quantity;
  int? remainedQuantity;

  CPRBusinessExternalPromotion(
      {required this.documentID,
        required this.id ,
        required this.title,
        required this.description,
        required this.startDate,
        required this.endDate ,
        required this.discount,
        required this.picture,
        required this.pictureURL,
        required this.placeId,
        required this.ownerEmail,
        required this.quantity,
        required this.remainedQuantity}) {
    if (id!.isEmpty) id = OtherHelper.getUUID().toUpperCase();
  }

  factory CPRBusinessExternalPromotion.fromJson(Map<String, dynamic> map) {
    var owner = CPRBusinessExternalPromotion(
      id: map["id"] ?? null,
      title: map["title"] ?? null,
      description: map["description"] ?? "",
      discount: map["discount"] ?? null,
      picture: map["picture"] ?? null,
      pictureURL: map["pictureURL"] ?? null,
      placeId: map["placeId"] ?? null,
      ownerEmail: map["ownerEmail"] ?? null,
      startDate: map["startDate"]!=null ? (map['startDate'] as Timestamp).toDate() : null,
      endDate: map["endDate"]!=null ?(map['endDate'] as Timestamp).toDate() : null, documentID: '',
      quantity: map["quantity"] ?? null,
      remainedQuantity: map["remainedQuantity"] ?? null,
    );
    return owner;
  }

  factory CPRBusinessExternalPromotion.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    var employee = CPRBusinessExternalPromotion.fromJson(map);
    employee.documentID = doc.id;
    return employee;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "title": title,
      "startDate": Timestamp.fromDate(startDate!),
      "endDate": Timestamp.fromDate(endDate!),
      "discount": discount,
      "picture": picture,
      "pictureURL": pictureURL,
      "placeId": placeId,
      "ownerEmail": ownerEmail,
      "quantity": quantity,
      "remainedQuantity": remainedQuantity,
    };
  }
}
