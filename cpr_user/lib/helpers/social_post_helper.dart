import 'dart:convert';

import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/services/social_post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/firebase.dart';
import '../services/social_profile_service.dart';
import 'string_helper.dart';

class SocialPostHelper {
  var db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!.email;

  String formatReviewText(Review review) {
    String reviewText = formatReview(review) +
        "\n${review.rating.toString()}" +
        "\n" +
        "Review posted by Click Pic Review. Click to download <href>www.clickpicreview.com</href>";

    return reviewText;
  }

// Send a post to the social networks you have enabled in the web dashboard.
  shareReview({required Review review}) async {
    String? profileKey = await SocialProfileService().getProfileKey(user!);
    String reviewText = formatReviewText(review);
    print('Starting SocialPostHelper.postToSocialMediaProfiles()');
    var url = Uri.parse('https://app.ayrshare.com/api/post');
    // List<String>? mediaURLs;

    /* if (review.downloadURLs!.isNotEmpty) {
      mediaURLs = review.downloadURLs;
    }
    if (review.videoDownloadURLs!.isNotEmpty) {
      mediaURLs!.add(review.videoDownloadURLs.toString());
    } */
    var response = await http.post(url,
        body: jsonEncode({
          'post': reviewText,
          'platforms': ['Facebook'],
          'mediaUrls': review.downloadURLs // for image for pinterest
          //   'mediaUrls': review.videoDownloadURLs //for videos
          //  'platforms': ['Twitter', 'TikTok', 'Pinterest'], //platforms,
          //  if (mediaURLs!.isNotEmpty) 'mediaUrls': mediaURLs
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + profileKey!,
        });
    print(
        'Printing the body in SocialPostHelper.postToSocialMediaProfiles() after post call');
    print(response.body);
    if (response.statusCode == 200) {
      print(
          'Printing the status code in SocialPostHelper.postToSocialMediaProfiles() after post call');
      print('Status Code: ${response.statusCode}');
      var output = json.decode(response.body);
      output['email'] = user;
      output['reviewId'] = review.firebaseId;
      print(output);
      SocialPostService().createSocialPost(output);
      print('Ending SocialPostHelper.postToSocialMediaProfiles()');
      return output;
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      var errResponse = json.decode(response.body);
      List errorList = errResponse['errors'];
      if (errorList.isNotEmpty) {
        Iterator it = errorList.iterator;
        while (it.moveNext()) {
          //  debugPrint(it.message);
        }
      }
    } else {
      print(json.decode(response.body));
      print('Failed to upload image or video.');
      print('Ending SocialPostHelper.postToSocialMediaProfiles()');
      throw Exception('Failed to upload image or video.');
    }
  }

  //Get a post - postId should be the Ayrshare top level post ID
  Future<List> getSocialMediaPost(String postId) async {
    String? profileKey = await SocialProfileService().getProfileKey(user!);
    Map<String, String> qParams = {'postId': postId};
    var url = Uri.parse('https://app.ayrshare.com/api/post/:id');
    final finalUrl = url.replace(queryParameters: qParams);
    var response = await http.get(
      finalUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + profileKey!,
      },
    );
    if (response.statusCode == 200) {
      var respObj = json.decode(response.body);
      debugPrint(respObj);
      return respObj;
    } else if (response.statusCode == 400) {
      var errResponse = json.decode(response.body);
      return errResponse['message'] + "for ID" + errResponse['id'];
    } else {
      throw Exception('Unable to fetch data from the Get Post API');
    }
  }

// Delete an existing Social Media Post - Only available for Business Plan
  deleteReview({required Review review}) async {
    print("Delete Review");
    String? profileKey = await SocialProfileService().getProfileKey(user!);
    print(profileKey);
    String postId =
        SocialPostService().findPostIdByReviewId(review.documentId) as String;
    //  print(postId);
    var url = Uri.parse('https://app.ayrshare.com/api/post');
    var response = await http.delete(url,
        body: jsonEncode(<String, String>{'id': postId}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + profileKey!,
        });
    if (response.statusCode == 200) {
      var respObj = json.decode(response.body);
      print(respObj);
      debugPrint(respObj);
      // todo - update social media post in db - need to test
      SocialPostService().deleteSocialPost(postId);
      return respObj;
    } else {
      print("Delete review in progress");
      print(json.decode(response.body));
      throw Exception('Failed to delete user post.');
    }
  }

//Update an existing Social Media Post - Only available for Business Plan
//todo - use document id from 'review' object to get post id from socialPost db collection, send review object in body
  editReview({required Review review}) async {
    String? profileKey = await SocialProfileService().getProfileKey(user!);
    var url = Uri.parse('https://app.ayrshare.com/api/post');

    String postId =
        SocialPostService().findPostIdByReviewId(review.documentId) as String;
    var response = await http.put(url,
        body: jsonEncode(<String, String>{'id': postId}),
        //schedule date also can be sent in the body/payload
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + profileKey!,
        });
    if (response.statusCode == 200) {
      var respObj = json.decode(response.body);
      debugPrint(respObj);
      // todo - update social media post in db - need to test
      await db
          .collection(FirestorePaths.socialpost)
          .doc(postId)
          .update(review.toJSON());
      return respObj;
    } else if (response.statusCode == 400) {
      var errResponse = json.decode(response.body);
      debugPrint(errResponse['message']);
    } else {
      throw Exception('Failed to update user post.');
    }
  }

//Shorten URL - useful for twitter - @todo
  Future<String> shortenURL(String linkToShorten, Map socialMedia) async {
    String? profileKey = await SocialProfileService().getProfileKey(user!);
    var url = Uri.parse('https://app.ayrshare.com/api/shorten');
    // 'linkToShorten': 'https://www.ayrshare.com'
    var response = await http.post(
      url,
      //  body: jsonEncode(<String, String>{'url': linkToShorten}),
      //below need to explore on socialMeta and how it is used,
      //where does this come from, is it sent to method as a parameter?

      body: jsonEncode({
        'url': 'linkToShorten',
        'socialMeta': {
          'title': 'title',
          'description': 'description',
          'mediaUrl': 'mediaURL'
        }
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + profileKey!,
      },
    );

    if (response.statusCode == 200) {
      var respObj = json.decode(response.body);
      debugPrint(respObj);
      return respObj['shortUrl'];
    } else {
      throw Exception('Unable to fetch data from the Get Post API');
    }
  }

  //Auto Hashatag endpoint
  //Generate hashtags for TikTok, Instagram, Twitter, LinkedIn, and YouTube.
  //Maximum post length is 1,000 characters. If over limit, hashtags will not be added.
  Future<List> autoAddHashTagsToPost() async {
    String? profileKey = await SocialProfileService().getProfileKey(user!);
    var url = Uri.parse('https://app.ayrshare.com/api/auto-hashtag');

    var response = await http.post(url,
        body: jsonEncode({
          'post': 'Today is a great day!',
          'max': 5, // optional, range 1-5
          'position': 'end' // optional, 'auto' or 'end'
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + profileKey!,
        });
    if (response.statusCode == 200) {
      //   debugPrint('Status Code: ${response.statusCode}');
      var output = json.decode(response.body);
      await db.collection('SocialPost').doc(user).set(output);
      return output;
    } else {
      throw Exception('Failed to upload image or video.');
    }
  }
}
