import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/sort_types.dart';
import 'package:cpr_user/interfaces/searchable.dart';
import 'package:flutter/material.dart';

class SearchProvider<T extends Searchable> with ChangeNotifier {
  // CPRSearchType type;
  List<T>? reviewsOrPlaces;
  List<T>? filteredReviewsOrPlaces;

  SearchProvider({ required this.reviewsOrPlaces}) {
    if(filteredReviewsOrPlaces==null)
      filteredReviewsOrPlaces = reviewsOrPlaces;
  }

  void filter(String text, double startRate, double endRate,GeoPoint currentLocation, double? distance) {

    //#abdo
    distance??= 0;

    if (reviewsOrPlaces != null) {
      filteredReviewsOrPlaces = List<T>.from(reviewsOrPlaces!).where((reviewOrPlace) => reviewOrPlace.find(text, startRate, endRate,currentLocation,distance!)==true).toList();
    }
    notifyListeners();
  }


  void sort(SortType type) {
    if (filteredReviewsOrPlaces != null) {
      if(type==SortType.ratingAscending)
      filteredReviewsOrPlaces!.sort((a,b)=>a.iconTile.compareTo(b.iconTile));
      if(type==SortType.ratingDescending)
      filteredReviewsOrPlaces!.sort((a,b)=>b.iconTile.compareTo(a.iconTile));
    }
    notifyListeners();
  }
}
