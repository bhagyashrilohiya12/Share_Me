import 'dart:io';

import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:flutter/material.dart';

class AddReviewsdfsdfProvider with ChangeNotifier {
  late Place _place;
  Review review = Review();
  List<File> _images = [];
  bool busy = false;

  AddReviewProvider({required Place place}) {
    _place = place;
    review.rating = 3;
    review.waiting = 3;
  }

  List<File> get images => _images;

  void addImage(File file) {
    _images.add(file);
    notifyListeners();
  }

  void removeImage(File file) {
    _images.remove(file);
    notifyListeners();
  }

  Place get place => _place;

  set place(p) {
    _place = p;
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


}
