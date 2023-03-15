import 'package:cpr_user/constants/cpr_urls.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _google = GoogleSignIn();
  // TwitterLogin _twitterLogin = new TwitterLogin(
  //   consumerKey: TwitterAPI.twitterAuthKey,
  //   consumerSecret: TwitterAPI.twitterAuthSecret,
  // );
//  FacebookLogin _facebookLogin = new FacebookLogin();

  // var _userService = UserService();

  Future<User> register(Map<String, String> map) async {
    var result = await _auth.createUserWithEmailAndPassword(email: map["email"]!, password: map['password']!);
    return result.user!;
  }

  Future<User> signInWithUserAndPassword({required username, required password}) async {
    var result = await _auth.signInWithEmailAndPassword(password: password, email: username);

    return result.user!;
  }

  Future<void> recoverPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<User> findCurrentUser() async {
    return _auth.currentUser!;
  }

  Future<void> signOut() async {
    Log.i("user - signOut() **** ");
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error while signing out of Firebase $e");
    }
    try {
      await _google.signOut();
    } catch (e) {
      print("Error while signing out of Google $e");
    }
    // try {
    //   await _twitterLogin.logOut();
    // } catch (e) {
    //   print("Error while signing out of Twitter $e");
    // }
//    try {
//      await _facebookLogin.logOut();
//    } catch (e) {
//      print("Error while signing out of Facebook $e");
//    }
  }

  Future<User> signInWithGoogle() async {
    var signedIn = await _google.isSignedIn();
    GoogleSignInAccount? googleAccount;
    if (!signedIn) {
      googleAccount = await _google.signIn();
    } else {
      googleAccount = _google.currentUser!;
    }

    var authentication = await googleAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    var firebaseUser = await _auth.signInWithCredential(credential);

    return firebaseUser.user!;
  }

  // Future<FirebaseUser> signInWithTwitter() async {
  //   // var loginResult = await _twitterLogin.authorize();
  //   // switch (loginResult.status) {
  //   //   case TwitterLoginStatus.loggedIn:
  //   //     final AuthCredential credential = TwitterAuthProvider.getCredential(
  //   //       authToken: loginResult.session.token,
  //   //       authTokenSecret: loginResult.session.secret,
  //   //     );
  //   //     var firebaseUser = (await _auth.signInWithCredential(credential)).user;
  //   //     return firebaseUser;
  //   //     break;
  //   //   case TwitterLoginStatus.error:
  //   //     return null;
  //   //     break;
  //   //   case TwitterLoginStatus.cancelledByUser:
  //   //     return null;
  //   //     break;
  //   // }
  //   // return null;
  // }

//  Future<User> signInWithFacebook() async {
//    var loginResult = await _facebookLogin.logIn(["email"]);
//
//    switch (loginResult.status) {
//      case FacebookLoginStatus.loggedIn:
//        final AuthCredential credential =
//            FacebookAuthProvider.credential(loginResult.accessToken.token);
//        var firebaseUser = (await _auth.signInWithCredential(credential)).user;
//
//        return firebaseUser;
//        break;
//      case FacebookLoginStatus.error:
//        return null;
//        break;
//      case FacebookLoginStatus.cancelledByUser:
//        return null;
//        break;
//    }
//    return null;
//  }
}
