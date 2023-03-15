import 'package:flutter/foundation.dart';

class FirestorePaths {
  static const placesCollectionRoot = !kDebugMode ? "places" : "places";
  static const reviewCollectionRoot = !kDebugMode ? "reviews" : "reviews";
  static const internalPromotionsCollectionRoot =
      !kDebugMode ? "internal_promotions" : "internal_promotions";
  static const externalPromotionsCollectionRoot =
      !kDebugMode ? "external_promotions" : "external_promotions";
  static const externalPromotionCouponsCollectionRoot =
      !kDebugMode ? "external_promotion_coupons" : "external_promotion_coupons";
  static const followingFollowerCollectionRoot =
      !kDebugMode ? "following_follower" : "following_follower";
  static const BlockedUserCollectionRoot =
      !kDebugMode ? "blocked_users" : "blocked_users";
  static const reviewLikeCollectionRoot =
      !kDebugMode ? "review_like" : "review_like";
  static const businessOwnersCollectionRoot =
      !kDebugMode ? "business_owners" : "business_owners";
  static const businessServersCollectionRoot =
      !kDebugMode ? "business_servers" : "business_servers";
  static const usersCollectionRoot = !kDebugMode ? "users" : "users";
  static const usersReviewsPlaces = !kDebugMode ? "reviews" : "reviews";
  static const usersSaveForLaterPlaces =
      !kDebugMode ? "saveForLaterPlaces" : "saveForLaterPlaces";
  static const usersFavoritesPlaces =
      !kDebugMode ? "favoritePlaces" : "favoritePlaces";
  static const usersDraftReviews = !kDebugMode ? "draft" : "draft";
  static const userLocations =
      !kDebugMode ? "user_locations" : "user_locations";
  static const reviewReports = !kDebugMode ? "review_report" : "review_report";
  static const analytics = !kDebugMode ? "analytics" : "analytics";
  static const socialprofile = !kDebugMode ? "socialProfile" : "socialProfile";
  static const socialpost = !kDebugMode ? "socialPost" : "socialPost";
}
