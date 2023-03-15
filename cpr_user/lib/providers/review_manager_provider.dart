import 'dart:io';

import 'package:cpr_user/models/business_internal_promotion.dart';
import 'package:cpr_user/models/business_server.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/services/reviews_service.dart';
import 'package:cpr_user/services/server_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReviewManagerProvider with ChangeNotifier {
  Place? _place;
  List<CPRBusinessServer?>? employees = [];

  CPRBusinessServer? selectedEmployee;
  List<CPRBusinessInternalPromotion> promotions = [];
  CPRBusinessInternalPromotion? selectedPromotion;
  bool usePromotion = false; //#Abdo
  Review? review;
  String userId = "";
  bool draftLoaded = false;

  List<File> _images = [];
  List<File> _videos = [];
  List<String> removedImages = [];
  List<String> removedVideos = [];
  ReviewService reviewService = new ReviewService();
  bool busy = false;

  var firstInputController = TextEditingController();
  var secondInputController = TextEditingController();
  var thirdInputController = TextEditingController();
  var fourthInputController = TextEditingController();
  var fifthInputController = TextEditingController();
  var fullReviewController = TextEditingController();

  CPRBusinessServer? singleEmployee;

  ReviewManagerProvider({required Review? rev, Place? place, required String userId}) {
    this.userId = userId;

    //case edit review
    if (rev != null) {
      if (place!.businessOwnerEmail != null) {
        findEmployees(place.businessOwnerEmail ?? "");
        employees!.add(CPRBusinessServer());
      }
      review = rev;
      _place = rev.place;
      _fillFieldsFromReview();

      // case : create new review
    } else {
      review = Review();
      if (place != null) {
        stopLoading();
        findDraftReview(place.googlePlaceID).then((s) => {});
        findEmployees(place.businessOwnerEmail ?? "");
        stopLoading();
      }
      _place = place;
    }
    if (review!.rating == null || review!.rating == 0) {
      review!.rating = 3.0;
    }
    if (review!.waiting == null || review!.waiting == 0) {
      review!.waiting = 3;
    }
  }

  _fillFieldsFromReview() {
    firstInputController.text = review!.serverName ?? "";
    secondInputController.text = review!.service ?? "";
    thirdInputController.text = review!.reasonOfVisit ?? "";
    fourthInputController.text = review!.companion ?? "";
    fifthInputController.text = review!.comments ?? "";
    fullReviewController.text = review!.fullReview ?? "";
    if (review!.server != null) {
      selectedEmployee = review!.server;
    }
    // print("Added data to selected emp ${review.server.firstName}");
  }

  Future<bool> findDraftReview(reviewId) async {
    try {
      var result = await reviewService.findDraftReviewByUserAndAndId(reviewId, userId);
      review = result;
      if (kDebugMode) {
        print("review ..$result");
      }
      _fillFieldsFromReview();
      draftLoaded = true;
      notifyListeners();
      return true;
    } catch (e) {
      review = Review();
      return false;
    }
  }

  List<File> get images => _images;

  List<File> get videos => _videos;

  String getImageUrl(String imageName) {
    if (review!.downloadURLs != null && review!.downloadURLs!.isNotEmpty) {
      String? url = review!.downloadURLs!.firstWhere((test) => test.contains(imageName));
      return url;
    }
    return '';
  }

  String getVideoUrl(String videoName) {
    if (review!.videoDownloadURLs != null && review!.videoDownloadURLs!.isNotEmpty) {
      String? url = review!.videoDownloadURLs!.firstWhere((test) => test.contains(videoName));
      return url;
    }
    return '';
  }

  bool get hasImagesInReview => (review!.images != null && review!.images!.isNotEmpty);

  bool get hasVideosInReview => (review!.videos != null && review!.videos!.isNotEmpty);

  void addImage(File file) {
    Log.i("addImage() - file: " + file.toString());
    _images.add(file);
    notifyListeners();
  }

  void addVideo(File file) {
    _videos.add(file);
    notifyListeners();
  }

  void removeImage(File file) {
    _images.remove(file);
    notifyListeners();
  }

  void removeVideo(File file) {
    _videos.remove(file);
    notifyListeners();
  }

  void removeRemoteImage(String image) {
    if (review!.downloadURLs != null) {
      String url = getImageUrl(image);
      review!.downloadURLs!.remove(url);
      review!.images!.remove(image);
      removedImages.add(url);
    }

    notifyListeners();
  }

  void removeRemoteVideo(String image) {
    if (review!.videoDownloadURLs != null) {
      String url = getImageUrl(image);
      review!.videoDownloadURLs!.remove(url);
      review!.videos!.remove(image);
      removedVideos.add(url);
    }

    notifyListeners();
  }

  Place? get place => _place;

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

  void findEmployees(String businessOwnerEmail) async {
    /**
     * //#Abdo
     *  //old code
        employees = await ServerService().findEmployees(businessOwnerEmail);
        //      singleEmployee = await ServerService().findSingleEmployees(businessOwnerEmail);
     */

    List<CPRBusinessServer?>? listBusiness = await ServerService().findEmployees(businessOwnerEmail);

    if (listBusiness == null) return;

    //loop
    for (var element in listBusiness) {
      if (element != null) {
        employees!.add(element);
      }
    }

    singleEmployee = await ServerService().findSingleEmployees(businessOwnerEmail);

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    firstInputController.dispose();
    secondInputController.dispose();
    thirdInputController.dispose();
    fourthInputController.dispose();
    fifthInputController.dispose();
    fullReviewController.dispose();
  }
}
