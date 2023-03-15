import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FcmHelper {
  static getToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String token = await messaging.getToken() ??"";
      print("FirebaseMessagingToken : " + token);

      return token;
    } catch (e) {
      return "";

    }
  }
}
