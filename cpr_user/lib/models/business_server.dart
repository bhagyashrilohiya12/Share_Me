import 'package:cloud_firestore/cloud_firestore.dart';


class CPRBusinessServer {
  String? documentID;
  String? id;
  String? firstName;
  String? surname;
  String? nickname;
  String? employer;
  String? jobTitle;
  String? profilePicture;
  String? profilePictureURL;

  CPRBusinessServer({
    this.documentID,
    this.id,
    this.firstName,
    this.surname,
    this.nickname,
    this.employer,
    this.jobTitle,
    this.profilePicture,
    this.profilePictureURL ,
  });

  factory CPRBusinessServer.fromJson(Map<String, dynamic> map) {
    var owner = CPRBusinessServer(
      id: map["id"] ?? null,
      firstName: map["firstName"] ?? null,
      surname: map["surname"] ?? null,
      nickname: map["nickname"] ?? null,
      employer: map["employer"] ?? null,
      jobTitle: map["jobTitle"] ?? null,
      profilePicture: map["profilePicture"]??null,
      profilePictureURL: map["profilePictureURL"]??null,
    );
    return owner;
  }

  factory CPRBusinessServer.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    var employee = CPRBusinessServer.fromJson(map);
    employee.documentID = doc.id;
    return employee;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "firstName": firstName,
      "surname": surname,
      "nickname": nickname,
      "employer": employer,
      "jobTitle": jobTitle,
      "profilePicture": profilePicture,
      "profilePictureURL": profilePictureURL,
    };
  }
}
