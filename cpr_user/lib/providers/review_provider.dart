import 'dart:io';

import 'package:cpr_user/constants/review_sorting.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/user/navigation_page.dart';
import 'package:cpr_user/services/reviews_service.dart';
import 'package:flutter/material.dart';

import '../Widgets/calendar_view.dart';

class ReviewProvider extends ChangeNotifier {
  List<Review> list = [];
  List<Review> reviewsByDays = [];
  bool isSelectedToday = true;
  String? currentPlaceId;
  Map<DateTime, List<Review>> monthlyReviews = {};
  DateTime? _currentCalenderMonth;
  late ReviewService _service;
  Review? lastReviewForGivenPlace;
  List<Review>? lastFiveReviewsByPlace;

  // CalendarController? calendarController;
  bool busy = false;

  DateTime? selectedDateByCalender;

  CalendarState? calendarState;

  ReviewService get service => _service;

  set service(ReviewService value) {
    _service = value;
  }

  set currentCalenderMonth(DateTime date) {
    _currentCalenderMonth = date;
  } //calender selectedMonthDate

  String sorting = ReviewSorting.CREATION_TIME;
  bool desc = true;

  ReviewProvider() {
    _service = ReviewService();
  }

  set selectedReviewDays(List<Review> reviews) {
    if (reviews == null) {
      reviews = [];
    }
    reviewsByDays = reviews;

    print("selectedReviewDays - reviewsByDays " + reviewsByDays.length.toString());

    notifyListeners();
  }

  get getIsSelectedToday {
    return isSelectedToday;
  }

  set SetIsSelectedDateToday(bool v) {
    isSelectedToday = v;
  }

  Future loadLastReviewByPlace(String placeId, {String? excludeReview, String? sort, bool? desc}) async {
    try {
      lastFiveReviewsByPlace = await _service.findLastReviewsByPlaceId(placeId, exclude: excludeReview, sort: sort, desc: desc);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<List<Review>> loadAllReviewsByPlace(String placeId) async {
    var results = await _service.findLastReviewsByPlaceId(placeId, limit: 100);
    return results;
    // notifyListeners();
  }

  Future<Review> findReview(String documentID) async {
    startLoading();
    var result = await _service.findReview(documentID);
    stopLoading();
    return result;
  }

  Future<Review> createReview(Review review, CPRUser user, {required List<File> images, required List<File> videos}) async {
    var response = await _service.createReview(review, user, images: images, videos: videos);
    // /list.add(response);
    return response;
  }

  Future<Review?> editReview(Review review, CPRUser user,
      {required List<File> images,
      required List<String> imagesToRemove,
      required List<File> videos,
      required List<String> videosToRemove}) async {
    if (review.documentId == null || review.documentId!.trim().isEmpty) {
      return null;
    }
    var response = await _service.editReview(review, user,
        images: images, imagesToRemove: imagesToRemove, videos: videos, videosToRemove: videosToRemove);
    // /list.add(response);
    return response;
  }

  void startLoading() {
    busy = true;
    notifyListeners();
  }

  void stopLoading() {
    busy = false;
    notifyListeners();
  }

  Future deleteReview(Review review, String userDocumentId) async {
    await _service.deleteReview(review, userDocumentId);
  }

  Future saveDraftReview(Review review, String userId, {required List<File> images, required List<File> videos,bool isUpdate = false}) async {
    print("review..${review}");
    await _service.saveDraftReview(review, userId, images: images, videos: videos,isUpdate:isUpdate);
  }

  Future<bool> deleteDraftReview(Review review, List<String> images, String userId) async {
    try {
      var result = await _service.deleteDraftReview(review, images, userId);
      return result!;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  //---------------------------------------------------------------------- event history height-light
  /***

      show event history
   */
  void loadHistoryEvent(CPRUser? user) {
    print("loadHistoryEvent() - start ");
    if (user == null) {
      return;
    }

    //check user not have review
    if (user.reviews == null) {
      List<Review>? emptyReviewList = [];
      this.list = emptyReviewList;
      return;
    }
    this.list = user.reviews!;
    monthlyReviews = {};

    //check have value
    if (this.list == null || this.list.isEmpty) {
      print("loadHistoryEvent() - list.isEmpty ");
      return;
    }



    //check there is mounted
    if (calendarState == null) {
      print("loadHistoryEvent() - calendarState == null  ");
      return;
    }

    list.forEach((review) {
      if (review.creationTime != null) {
        if (review.when == null) {
          return;
        }

        if (stateNavigationPage!.mounted == false) {
          print("loadHistoryEvent() - stateNavigationPage!.mounted == false - stop !  ");
          return;
        }
        DateTime reviewDay = DateTime(review.when!.year, review.when!.month, review.when!.day);
        if (_currentCalenderMonth == null || review.when!.month == _currentCalenderMonth?.month) {
          if (!review.archived!) {
            calendarState!.event_dateUpdate(reviewDay, review.firebaseId!);
            print(
                "loadHistoryEvent() - loop day: " + reviewDay.month.toString() + "-" + reviewDay.day.toString() + "-" + review.firebaseId!);
          }
        }
        if (monthlyReviews[reviewDay] != null) {
          monthlyReviews[reviewDay]!.add(review);
        } else {
          monthlyReviews.putIfAbsent(reviewDay, () => [review]);
        }
      }
    });

    //
    //notifyListeners();
  }

}
