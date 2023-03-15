import 'package:cpr_user/services/places_service.dart';
import 'package:flutter/material.dart';

class HomeImageProvider with ChangeNotifier{
  String homeImageUrl = "";
  var placeService = PlacesService();

  HomeImageProvider(){
    findHomeImageUrl();
  }
  Future<void> findHomeImageUrl() async{
    homeImageUrl = await placeService.findRandomReviewImage(limit: 20);
    notifyListeners();
  }
}