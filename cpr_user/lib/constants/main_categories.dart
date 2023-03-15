import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'network_error_codes.dart';

enum MainCategory {
  promotions,
  restaurants,
  salons,
  bars,
  cafes,
  hotels,
  wellbeing,
  myFavoritePlaces,
  saveForLaterPlaces,
  coupons,
  myReviews,
  myDraftReviews,
}

class MainCategoryUtil {


  static String getDisplayName(MainCategory cat) {
    switch (cat) {
      case MainCategory.promotions:
        return "Promotions";
      case MainCategory.bars:
        return "Bars and Taverns";
      case MainCategory.hotels:
        return "Hotels";
      case MainCategory.wellbeing:
        return "Wellbeing";
      case MainCategory.cafes:
        return "Coffee Shops";
      case MainCategory.restaurants:
        return "Restaurants";
      case MainCategory.saveForLaterPlaces:
        return "Places I'll go Later";
      case MainCategory.salons:
        return "Salons and Spas";
      case MainCategory.myFavoritePlaces:
        return "My Favorite Places";
      case MainCategory.coupons:
        return "coupons";
      case MainCategory.myReviews:
        return "My Reviews";
      case MainCategory.myDraftReviews:
        return "My Draft Reviews";
    }
    return  "";
  }

  static String getCategoryFromDisplayName(String cat) {
    switch (cat) {
      case "Bars and Taverns":
        return "bar";
      case "Hotels":
        return "lodging";
      case "Wellbeing":
        return "health";
      case "Coffee Shops":
        return "cafe";
      case "Restaurants":
        return  "restaurant";
      case "Salons and Spas":
        return "hair_care";
      case "All":
        return "";
    }
    return "";
  }


  static String getName(MainCategory cat) {
    switch (cat) {
      case MainCategory.promotions:
        return "Promotions";
      case MainCategory.bars:
        return "bars";
      case MainCategory.hotels:
        return "hotels";
      case MainCategory.wellbeing:
        return "Wellbeing";
      case MainCategory.cafes:
        return "cafes";
      case MainCategory.restaurants:
        return "restaurants";
      case MainCategory.saveForLaterPlaces:
        return "sfl";
      case MainCategory.salons:
        return "salons";
      case MainCategory.myFavoritePlaces:
        return "favorite";
      case MainCategory.coupons:
        return "coupons";
      case MainCategory.myReviews:
        return "my_reviews";
      case MainCategory.myDraftReviews:
        return "my_draft_reviews";
    }
    return "";
  }

  static String getGooglePlacesName(MainCategory category) {
    switch (category) {
      case MainCategory.bars:
        return "bar";
      case MainCategory.restaurants:
        return "restaurant";
      case MainCategory.salons:
        return "hair_care";
      case MainCategory.cafes:
        return "cafe";
      case MainCategory.hotels:
        return "lodging";
      case MainCategory.wellbeing:
        return "health";
      default:
        return "";
    }
  }

  static MainCategory getGooglePlacesCategoryFromName(String name) {
    switch (name) {
      case "bar":
        return MainCategory.bars;
      case "restaurant":
        return MainCategory.restaurants;
      case "hair_care":
        return MainCategory.salons;
      case "cafe":
        return MainCategory.cafes;
      case "lodging":
        return MainCategory.hotels;
      case "health":
        return MainCategory.wellbeing;
      default:
        return MainCategory.bars;
    }
  }

  static String getPlacesIconFromNames(List<String> names) {
    if(names.contains("bar")) {
      return "assets/images/ic_glass.png";
    }else if(names.contains("restaurant")) {
      return "assets/images/ic_fork_knife.png";
    }else if(names.contains("hair_care")) {
      return "assets/images/ic_seat.png";
    }else if(names.contains("cafe")) {
      return "assets/images/ic_coffee.png";
    }else if(names.contains("lodging")) {
      return "assets/images/ic_hotel.png";
    }else if(names.contains("health")) {
      return "assets/images/ic_health_and_safety.png";
    }else {
      return "assets/images/ic_blocks.png";
    }
  }
  static Color getPlacesColorFromNames(List<String> names) {
    if(names.contains("bar")) {
      return Color(0xff37b6e7);
    }else if(names.contains("restaurant")) {
      return Color(0xff44b94a);
    }else if(names.contains("hair_care")) {
      return Color(0xfff83797);
    }else if(names.contains("cafe")) {
      return Color(0xfff73998);
    }else if(names.contains("lodging")) {
      return Color(0xff44b94a);
    }else if(names.contains("health")) {
      return Color(0xff2e98c3);
    }else {
      return Color(0xff44b94a);
    }
  }

  static String getPlacesNameFromNames(List<String> names) {
    if(names.contains("bar")) {
      return "bar";
    }else if(names.contains("restaurant")) {
      return "restaurant";
    }else if(names.contains("hair_care")) {
      return "salon";
    }else if(names.contains("cafe")) {
      return "cafe";
    }else if(names.contains("lodging")) {
      return "hotel";
    }else if(names.contains("health")) {
      return "wellbeing";
    }else {
      return "-";
    }
  }
  static List<String> getGooglePlacesNames() {
    List<String> name = [];
    name.add("bar");
    name.add("restaurant");
    name.add("hair_care");
    name.add("cafe");
    name.add("lodging");
    name.add("health");
    return name;
  }

  static bool isCategorized(MainCategory cat) {
    switch (cat) {
      case MainCategory.myReviews:
      case MainCategory.myDraftReviews:
      case MainCategory.myFavoritePlaces:
      case MainCategory.saveForLaterPlaces:
        return false;
      default:
        return true;
    }
  }





}
