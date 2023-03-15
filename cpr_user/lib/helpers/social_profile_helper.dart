import 'dart:convert';

import 'package:cpr_user/constants/social_config.dart';
import 'package:cpr_user/services/social_profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SocialProfileHelper {
  var db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!.email;
  late BuildContext context;

// Get all Ayrshare profiles linked to primary account

  Future getUserProfiles() async {
    var url = Uri.parse('https://app.ayrshare.com/api/profiles');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': SocialConfig.ProfileKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Unable to fetch data from the Get User Profile API for all users');
    }
  }

//// Get Ayrshare profile based on profile key

  Future getUserProfile(user) async {
    String? profileKey = await SocialProfileService().getProfileKey(user!);
    Map<String, String?> qParams = {'profilekey': profileKey};
    var url = Uri.parse('https://app.ayrshare.com/api/profiles');
    final finalUrl = url.replace(queryParameters: qParams);
    var response = await http.get(finalUrl, headers: {
      'Content-Type': 'application/json',
      'Authorization': SocialConfig.ProfileKey,
    });
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(
          'Unable to fetch data from Get User Profile API for particular user');
    }
  }

// Create a new Ayrshare profile

  Future createUserProfile(String user) async {
    final email = user.split('@');
    String? title = email.first;
    bool hidetitle = true;
    var url = Uri.parse('https://app.ayrshare.com/api/profiles/profile');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': SocialConfig.ProfileKey,
      },
      body: jsonEncode({
        'title': title,
        'hidetitle': hidetitle.toString(),
        'disableSocial': [
          'fbg',
          'linkedin',
          'telegram',
          'gmb',
          'youtube',
          'reddit'
        ]
      }),
    );
    if (response.statusCode == 200) {
      var output = json.decode(response.body);
      var opt = await SocialProfileService().createSocialProfile(user, output);
      return response;
    } else {
      throw Exception('Failed to create user profile.');
    }
  }

// Update Ayrshare user profile

  Future<List> updateUserProfile(String title) async {
    String? profileKey = await SocialProfileService().getProfileKey(user!);
    var url = Uri.parse('https://app.ayrshare.com/api/profiles/profile');
    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': SocialConfig.ProfileKey,
      },
      body: jsonEncode(<String, String?>{
        'profileKey': profileKey,
        'title': title,
      }),
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body));
    } else {
      throw Exception('Failed to update user profile.');
    }
  }

// Delete Ayrshare user profile

  Future<List> deleteUserProfile() async {
    String? profileKey = await SocialProfileService().getProfileKey(user!);
    var url = Uri.parse('https://app.ayrshare.com/api/profiles/profile');
    var response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': SocialConfig.ProfileKey,
      },
      body: jsonEncode(<String, String?>{'profileKey': profileKey}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete user profile.');
    }
  }

  //// Unlink user social media account

  Future<List> unlinkSocialMediaAccount(String platform) async {
    String? profileKey = await SocialProfileService().getProfileKey(user!);
    var url = Uri.parse('https://app.ayrshare.com/api/profiles/profile');
    var response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': SocialConfig.ProfileKey,
      },
      body: jsonEncode(
          <String, String?>{'profileKey': profileKey, 'platform': platform}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to unlink social media account for user profile.');
    }
  }

  // Generate jwt

  Future generateJWT() async {
    String privateKey = await rootBundle.loadString('assets/private_key.key');
    //  String data = await getFileData(fileName);
    String? profileKey = await SocialProfileService().getProfileKey(user!);
    String domain = 'clickpicreview';
    var url = Uri.parse('https://app.ayrshare.com/api/profiles/generateJWT');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': SocialConfig.ProfileKey,
      },
      body: jsonEncode(<String, String?>{
        'privateKey': privateKey,
        'profileKey': profileKey,
        'domain': domain,
        'redirect': 'https://clippicreview.web.app/#/'
      }),
    );
    if (response.statusCode == 200) {
      var output = json.decode(response.body);
      var url = output['url'];
      return url;
    } else {
      throw Exception('Failed to generate JWT.');
    }
  }
}
