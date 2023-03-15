import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';

class SocialPost {
  String? email;
  Array? errors;
  String? id;
  String? post;
  Array? postIds;
  String? refId;
  String? reviewId;
  String? status;

  SocialPost({
    this.email,
    this.errors,
    this.id, //this is the top level social media post id that can be used for edit/delete/analytics
    this.post,
    this.postIds,
    this.refId,
    this.reviewId,
    this.status,
  });

  factory SocialPost.fromJson(Map<String?, dynamic> map) {
    SocialPost socialPost = SocialPost();
    if (map == null) map = new Map<String?, dynamic>();
    try {
      socialPost = SocialPost();
      socialPost.email = map["email"] != null ? map["email"] : null;
      socialPost.errors = map["errors"] != null ? map["errors"] : null;
      socialPost.id = map["id"] != null ? map["id"] : null;
      socialPost.post = map["post"] != null ? map["post"] : null;
      socialPost.postIds = map["postIds"] != null ? map["postIds"] : null;
      socialPost.refId = map["refId"] != null ? map["refId"] : null;
      socialPost.reviewId = map["reviewId"] != null ? map["reviewId"] : null;
      socialPost.status = map["status"] != null ? map["status"] : null;
    } catch (e) {
      print("Social Post Model => " + "error $e");
    }
    return socialPost;
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "errors": errors,
        "id": id,
        "post": post,
        "postIds": postIds,
        "refId": refId,
        "reviewId": reviewId,
        "status": status,
      };

  factory SocialPost.fromDocumentSnapshot(DocumentSnapshot f) {
    var socialPost = SocialPost.fromJson(f.data() as Map<String, dynamic>);
    try {
      socialPost.id = f.id;
    } catch (e) {
      print(e);
    }
    return socialPost;
  }
}
