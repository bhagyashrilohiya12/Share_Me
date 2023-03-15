import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/firebase.dart';
import 'package:cpr_user/models/social_post.dart';

class SocialPostService {
  var db = FirebaseFirestore.instance;

  //// Store posts in firebase
  Future createSocialPost(var output) async {
    await db.collection(FirestorePaths.socialpost).add(output!);
  }

  //// get postid based on reviewid in firebase
  Future<String?> findPostIdByReviewId(String? documentId) async {
    print(documentId);
    SocialPost socialPost = SocialPost();
    var myreviews = await db
        .collection(FirestorePaths.socialpost)
        .where("reviewId", isEqualTo: documentId)
        .get();
    print(myreviews);
    List<SocialPost> reviews = myreviews.docs
        .map((socialPosts) => SocialPost.fromJson(socialPosts.data()))
        .toList();
    print(reviews);
    if (reviews.isNotEmpty && reviews.length > 0) {
      socialPost = reviews.first;
    }
    print(socialPost.id);
    return socialPost.id;
  }

  //// delete post based on postid in firebase
  Future deleteSocialPost(String postId) async {
    await db.collection(FirestorePaths.socialpost).doc(postId).delete();
  }
}
