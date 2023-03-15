import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlacesProvider with ChangeNotifier {
  List<Place>? _places;
  double distance = 0 ;
  String currentPlace = "";

  bool busy = false;
  var service = PlacesService();

  List<Place>? get allPlaces => _places;

  String? get formattedDistance {
    if (distance == null) {
      return null;
    }
    var formatter = NumberFormat.decimalPattern();
    formatter.maximumFractionDigits = 0;
    return formatter.format(distance);
  }

  Future<Place?> findPlace(String placeId) async {
    try {
      var result = await service.findPlaceById(placeId);
      return result!;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Place> addPlace(Place place) async {
    return await service.addPlace(place);
  }

  void refresh() {
    notifyListeners();
  }

  void startLoading() {
    busy = true;
    notifyListeners();
  }

  void stopLoading() {
    busy = false;
    notifyListeners();
  }

  Future<List<Place>?> findPlacesByCategory(GeoPoint currentLocation, MainCategory category) async {


    return await service.getTopRateNearPlace(
        currentLocation, MainCategoryUtil.getGooglePlacesName(category),total: 1000);
  }

  Future<Place> updatePlaceDetail(String documentId, Map<String, dynamic> values) async {
    return await service.updatePlaceDetail(documentId, values);
  }
}
