import 'dart:io';
import 'dart:typed_data';

import 'package:cpr_user/models/review.dart';
// import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';
//import 'package:share_api/composers/facebook_story.dart';
// import 'package:share_api/share_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ShareHelper {
  static Future sharseReview(Review review) async {}

  static Future<Uint8List> _networkImage(String url) async {
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    return bytes;
  }

  static Future<void> shareWithInstagram(Review review) async {
    try {
      var url = review.downloadURLs![0];
      await launch("instagram://location?id=1");
      // if (review.downloadURLs != null && review.downloadURLs.isNotEmpty) {
      //   var url = review.downloadURLs[0];
      //   var bytes = await _networkImage(url);
      //   try {
      //     // SocialSharePlugin.shareToFeedFacebook(, review.downloadURLs[0]);

      //     await launch("instagram://camera");
      //     // await Share.file(
      //     //     'Share Review', "${review.place.name}.igo", bytes, 'public/jpeg',
      //     //     text: review.comments);
      //   } catch (e) {
      //     Share.text("Share Review", review.comments, "text/plain");
      //   }
      // } else {
      //   Share.text("Share Review", review.comments, "text/plain");
      // }
    } catch (e) {
      print('Share error: $e');
    }
  }

  static Future<void> shareWithSystemUI(Review review) async {
    try {
      if (review.downloadURLs != null && review.downloadURLs!.isNotEmpty) {
        var url = review.downloadURLs![0];
        var bytes = await _networkImage(url);
        try {
          // SocialSharePlugin.shareToFeedFacebook(, review.downloadURLs[0]);
          // await Share.file(
          //     'Share Review', "${review.place.name}.jpg", bytes, 'image/jpg',
          //     text: review.comments);
        } catch (e) {
          // Share.text("Share Review", review.comments, "text/plain");
        }
      } else {
        // Share.text("Share Review", review.comments, "text/plain");
      }
    } catch (e) {
      print('Share error: $e');
    }
  }

  static Future<void> shareWithFacebook(Review review) async {
    try {
      if (review.downloadURLs != null && review.downloadURLs!.isNotEmpty) {
        var url = review.downloadURLs![0];
        // var bytes = await _networkImage(url);
        try {
          // FlutterShareMe().shareToFacebook(
          //     url: review.downloadURLs[0], msg: review.comments);

          // await SocialSharePlugin.shareToFeedFacebook(review.comments, url);
          // SocialSharePlugin.shareToFeedFacebook(, review.downloadURLs[0]);
          // await Share.file(
          //     'Share Review', "${review.place.name}.jpg", bytes, 'image/jpg',
          //     text: review.comments);
        } catch (e) {
          print('Error sharing review with Image.: $e');
          print("Trying to share comments only");
          // Share.text("Share Review", review.comments, "text/plain");
        }
      } else {
        // FlutterShareMe().shareToFacebook(
        //     msg: review.comments,
        //     url:
        //         'https://lh3.googleusercontent.com/aM04D4QrPf6q47d_lqt0ddjouD5Ilu64iBY0VEUmr99O3ITUMxT-f1erWZWT5qqBOcOqjYGGfx-_xeKZ38rd1g');
      }
    } catch (e) {
      print('Share error: $e');
    }
  }

  static Future<void> shareToInstagram(Review review) async {
    try {
      if (review.downloadURLs != null && review.downloadURLs!.isNotEmpty) {
        var url = review.downloadURLs![0];
        print('Insta url - ' + url);
        // var bytes = await _networkImage(url);
        try {
          http.Response response = await http.get(Uri.parse(url));
          var bytedata = response.bodyBytes;

//          var composer = FacebookStoryComposer(
//            backgroundAsset: bytedata,
//            backgroundMediaType: 'image/*',
//            stickerAsset: bytedata,
//            stickerMediaType: 'image/*',
//            topBackgroundColor: Color(0xFFFF0000),
//            bottomBackgroundColor: Color(0xFF00FF00),
//          );
          // s.contentUrl = url;
//          ShareApi.viaInstagram.shareToStory(composer);
          // FlutterShareMe().Shar(
          //     url: review.downloadURLs[0], msg: review.comments);

          // await SocialSharePlugin.shareToFeedFacebook(review.comments, url);
          // SocialSharePlugin.shareToFeedFacebook(, review.downloadURLs[0]);
          // await Share.file(
          //     'Share Review', "${review.place.name}.jpg", bytes, 'image/jpg',
          //     text: review.comments);
        } catch (e) {
          print('Error sharing review with Image.: $e');
          print("Trying to share comments only");
          // Share.text("Share Review", review.comments, "text/plain");
        }
      } else {
        // FlutterShareMe().shareToFacebook(
        //     msg: review.comments,
        //     url:
        //         'https://lh3.googleusercontent.com/aM04D4QrPf6q47d_lqt0ddjouD5Ilu64iBY0VEUmr99O3ITUMxT-f1erWZWT5qqBOcOqjYGGfx-_xeKZ38rd1g');
      }
    } catch (e) {
      print('Share error: $e');
    }
  }

  // static Future<void> _shareImageFromUrl(String url) async {}
}
