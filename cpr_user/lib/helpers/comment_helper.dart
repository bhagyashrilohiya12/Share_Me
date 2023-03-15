import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/social_profile_service.dart';

class CommentHelper {
  var db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!.email;

//// Get id from firebase based on email id
  Future<String> getPostID(String user) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('socialpost').doc(user);
    String postid = 'default';
    await documentReference.get().then((snapshot) {
      postid = snapshot['id'].toString();
    });
    return postid;
  }

//Get the comments for a given top-level post ID.
//Available for Facebook Pages, Instagram, LinkedIn, Twitter, and YouTube.

  Future<List> getComments() async {
    String id = await getPostID(user!);
    String? profileKey = await SocialProfileService().getProfileKey(user!);
    Map<String, String?> qParams = {'id': id};
    var url = Uri.parse('https://app.ayrshare.com/api/comments/:id');
    final finalUrl = url.replace(queryParameters: qParams);
    var response = await http.get(finalUrl, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + profileKey!,
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Unable to fetch comment');
    }
  }

//Add a comment to a post.
//Available for Facebook Pages, Instagram, YouTube, and Twitter.

  Future<List> postComment(String comment, List platforms) async {
    String id = await getPostID(user!);
    String? profileKey = await SocialProfileService().getProfileKey(user!);
    var url = Uri.parse('https://app.ayrshare.com/api/comments');
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + profileKey!,
        },
        body: jsonEncode(
          {'id': id, 'comment': comment, 'platforms': []},
        ));
    if (response.statusCode == 200) {
      var output = json.decode(response.body);
      print(output);
      await db.collection('SocialComments').doc(user).set(output);
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw Exception('Failed to post comment on social media account.');
    }
  }
}
