import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/photo_view_page.dart';
import 'package:cpr_user/pages/user/review_manager/review_manager_page.dart';
import 'package:cpr_user/pages/user/login/login_screen.dart';
import 'package:cpr_user/pages/user/navigation_page.dart';
import 'package:cpr_user/pages/user/places_details_page/place_detail_page.dart';
import 'package:cpr_user/pages/user/my_profile_page/components/configure_page.dart';
import 'package:cpr_user/pages/user/review_details_page/review_details_page.dart';
import 'package:cpr_user/pages/user/splash_screen.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';

class CPRRoutes {
  static MaterialPageRoute placesDetailPage(Place place,
          {GeoPoint? userLocation, String? categoryName, Review? review}) =>
      MaterialPageRoute(
        builder: (context) => PlacesDetailPage(
          place: place,
          categoryName: categoryName,
          review: review,
        ),
      );

  static MaterialPageRoute reviewDetailPage(Review review, Place place,
          {GeoPoint? userLocation}) =>
      MaterialPageRoute(
        builder: (context) => ReviewDetailsPage(
          review: review,
          place: place,
        ),
      );

  static void navigationPage(BuildContext context) =>
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => NavigationPage(),
        ),
      );

  static void splashScreen(BuildContext context) =>
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
      );

  static createReview(BuildContext context,
      {Place? place, bool? usePromotion, bool? canDeleteDraftReview}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReviewManagerPage(
          place: place,
          usePromotion: usePromotion ?? false,
          canDeleteDraftReview: canDeleteDraftReview ?? false,
        ),
      ),
    );
  }

  //todo:16/09/2022 : new function create for review data passing.
  static createReview2(BuildContext context,
      {required Review review,
      Place? place,
      bool? usePromotion,
      bool? canDeleteDraftReview}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReviewManagerPage(
          review: review,
          place: place,
          usePromotion: usePromotion ?? false,
          canDeleteDraftReview: canDeleteDraftReview ?? false,
        ),
      ),
    );
  }

  static void editReview(BuildContext context, {required Review review}) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReviewManagerPage(
            review: review,
          ),
        ),
      );

  static void photoView(BuildContext context, {String? url, String? path}) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoViewPage(
            imagePath: path,
            imageUrl: url,
          ),
        ),
      );

  static void loginScreen(BuildContext context) {
    try {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  static void configurePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConfigurePage(),
      ),
    );
  }
}
