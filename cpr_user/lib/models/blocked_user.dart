import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/models/user.dart';

class CPRBlockedUser {
  String? documentID;
  String? id;
  String? blockerId;
  String? blockedId;
  CPRUser? blocker;
  CPRUser? blocked;

  CPRBlockedUser({required this.documentID, required  this.id,
    required this.blockerId,required  this.blockedId,required  this.blocker,required  this.blocked}) {
    if (id == null) id = OtherHelper.getUUID().toUpperCase();
  }

  factory CPRBlockedUser.fromJson(Map<String, dynamic> map) {
    var follow = CPRBlockedUser(
      id: map["id"] ?? null,
      blockerId: map["blockerId"] ?? null,
      blockedId: map["blockedId"] ?? null,
      blocker: map["blocker"] != null ? CPRUser.fromJson(map["blocker"]) : null,
      blocked: map["blocked"] != null ? CPRUser.fromJson(map["blocked"]) : null, documentID: '',
    );
    return follow;
  }

  factory CPRBlockedUser.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    var follow = CPRBlockedUser.fromJson(map);
    follow.documentID = doc.id;
    return follow;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "blockerId": blockerId,
      "blockedId": blockedId,
      "blocker": blocker != null ? blocker!.toJSON() : null,
      "blocked": blocked != null ? blocked!.toJSON() : null,
    };
  }
}
