import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/helpers/other_helper.dart';
import 'package:cpr_user/models/user.dart';

class CPRFollowerFollowing {
  String? documentID;
  String? id;
  String? followerId;
  String? followingId;
  CPRUser? follower;
  CPRUser? following;

  CPRFollowerFollowing({this.documentID, this.id, this.followerId, this.followingId, this.follower, this.following}) {
    if (id == null) id = OtherHelper.getUUID().toUpperCase();
  }

  factory CPRFollowerFollowing.fromJson(Map<String, dynamic> map) {
    var follow = CPRFollowerFollowing(
      id: map["id"] ?? null,
      followerId: map["followerId"] ?? null,
      followingId: map["followingId"] ?? null,
      follower: map["follower"] != null ? CPRUser.fromJson(map["follower"]) : null,
      following: map["following"] != null ? CPRUser.fromJson(map["following"]) : null,
    );
    return follow;
  }

  factory CPRFollowerFollowing.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    var follow = CPRFollowerFollowing.fromJson(map);
    follow.documentID = doc.id;
    return follow;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "followerId": followerId,
      "followingId": followingId,
      "follower": follower != null ? follower!.toJSON() : null,
      "following": following != null ? following!.toJSON() : null,
    };
  }
}
