import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/helpers/location_helper.dart';
import 'package:cpr_user/models/added_place.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/services/auth_service.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:cpr_user/services/reviews_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CategoryStreamProvider with ChangeNotifier {
  User? firebaseUser;
  CPRUser? user;
  Map<MainCategory, List<dynamic>> _places = {};
  GeoPoint? currentLocation;
  List<Place> _restaurants = [];
  List<Place> _salons = [];
  List<Place> _bars = [];
  List<Place> _hotels = [];
  List<Place> _cafes = [];

  List<Place> _favorites = [];
  List<Place> _saveForLater = [];
  List<Review> _myReview = [];

  final _restaurantController = StreamController<List<Place>>.broadcast();
  final _barController = StreamController<List<Place>>.broadcast();
  final _salonController = StreamController<List<Place>>.broadcast();
  final _hotelController = StreamController<List<Place>>.broadcast();
  final _cafeControllers = StreamController<List<Place>>.broadcast();
  final _sflController = StreamController<List<Place>>.broadcast();
  final _favoritesControllers = StreamController<List<Place>>.broadcast();
  final _myReviewsControllers = StreamController<List<Review>>.broadcast();

  Stream? getStreamOutByCategory(MainCategory cat) {
    switch (cat) {
      case MainCategory.restaurants:
        return _restaurantController.stream;
      case MainCategory.bars:
        return _barController.stream;
      case MainCategory.salons:
        return _salonController.stream;
      case MainCategory.hotels:
        return _hotelController.stream;
      case MainCategory.cafes:
        return _cafeControllers.stream;
      case MainCategory.saveForLaterPlaces:
        return _sflController.stream;
      case MainCategory.myFavoritePlaces:
        return _favoritesControllers.stream;
        break;
      case MainCategory.myReviews:
        return _myReviewsControllers.stream;
        break;
      default:
        return null;
    }
  }

//
//  final _controller = StreamController<List<dynamic>>.broadcast();
//  Stream get controllerOut => _controller.stream;
//  StreamSink get controllerIn => _controller.sink;

  var service = UserService();

  var placeService = PlacesService();
  var _authService = AuthService();

  bool busy = false;
  var _currentIndex = 0;


  CategoryStreamProvider();
  String? get profileURL => user != null ? user!.profilePictureURL : null;

  int get reviewCount {
    if (_places[MainCategory.myReviews] != null) {
      return _places[MainCategory.myReviews]!.length;
    }
    return 0;
  }

  get places => _places;

  int get saveForLaterCount {
    if (_places[MainCategory.saveForLaterPlaces] != null) {
      return _places[MainCategory.saveForLaterPlaces]!.length;
    }
    return 0;
  }

  int get favoritesCount {
    if (_places[MainCategory.myFavoritePlaces] != null) {
      return _places[MainCategory.myFavoritePlaces]!.length;
    }
    return 0;
  }

  int get prizes => 2;

  String? get displayName =>
      user != null && user!.displayName != null ? user!.displayName : "";

  Future findUserInformation() async {
    try {
      user = await service.findUser(firebaseUser!.email!, firebaseUser!);
    } catch (e) {
      print(e);
    }
  }

  Future findCurrentLocation() async {
    currentLocation = await LocationHelper.userLocation();
  }

  Future addToCategory(Place place, MainCategory category) async {
    await service.addToCategory(user!, place, category);
    var list = await refreshCategory(category);
    var currentList = _places[category];
    if (currentList == null) {
      _places.putIfAbsent(category, () => list!);
    } else {
      _places.update(category, (l) => list!);
    }
  }

  Future removeFromCategory(Place place, MainCategory category) async {
    await service.removeFromCategory(user!, place, category);
    var list = await refreshCategory(category);
    var currentList = _places[category];
    if (currentList == null) {
      _places.putIfAbsent(category, () => list!);
    } else {
      _places.update(category, (l) => list!);
    }
  }

  Future<List<dynamic>?> refreshCategory(MainCategory category) async {
    switch (category) {
      case MainCategory.myFavoritePlaces:
        return await placeService.findFavoritePlaces(user!.documentID!);
        break;
      case MainCategory.saveForLaterPlaces:
        return await placeService.findSaveForLaterPlaces(user!.documentID!);
        break;

      default:
        return null;
    }
  }

  bool isInCategory(Place place, MainCategory category) {
    try {
      var result = _places[category]!.contains(place);
      return result;
    } catch (e) {}
    return false;
  }

  Future<String> loadCategorizedPlaces(User user, MainCategory category) async {
    var userId = user.email;
    if (currentLocation == null) {
      await findCurrentLocation();
    }

    try {
      if (userId != null) {
        List<Place>? list;
        if (MainCategoryUtil.isCategorized(category)) {
          list = await placeService.getTopRateNearPlace(currentLocation!,
              MainCategoryUtil.getGooglePlacesName(category));
        }

        switch (category) {
          case MainCategory.myFavoritePlaces:
            _favorites = await placeService.findFavoritePlaces(userId);
            _favoritesControllers.sink.add(_favorites);
            break;
          case MainCategory.saveForLaterPlaces:
            _saveForLater = await placeService.findSaveForLaterPlaces(userId);
            _sflController.sink.add(_saveForLater);
            break;
          case MainCategory.myReviews:
            _myReview = await placeService.findReviewsPlaces(userId);
            _myReviewsControllers.sink.add(_myReview);
            break;
          case MainCategory.restaurants:
            _restaurants = list!;
            _restaurantController.sink.add(_restaurants);
            break;
          case MainCategory.bars:
            _bars = list!;
            _barController.sink.add(_bars);
            break;
          case MainCategory.cafes:
            _cafes = list!;
            _cafeControllers.sink.add(_cafes);
            break;
          case MainCategory.hotels:
            _hotels = list!;
            _hotelController.sink.add(_hotels);
            break;
          case MainCategory.salons:
            _salons = list!;
            _salonController.sink.add(_salons);

            break;
          default:
            break;
        }

        if (list != null && list.isNotEmpty) {
//            _places.putIfAbsent(category, () => list);
//            controllerIn.add(_places);
//            notifyListeners();
        }
      }
      return "OK";
    } catch (e) {
      return "ERROR";
    }
  }

  Future refreshReviews() async {
    var list = await placeService.findReviewsPlaces(user!.documentID!);
    if (list != null && list.isNotEmpty) {
      _places.remove(MainCategory.myReviews);
      _places.putIfAbsent(MainCategory.myReviews, () => list);
    }
  }

  void startLoading() {
    busy = true;
  }

  void stopLoading() {
    busy = false;
  }

  Future<bool> signInWithEmailAndPassword(String user, String pass) async {
    firebaseUser = await _authService.signInWithUserAndPassword(
        username: user, password: pass);
    if (firebaseUser != null) {
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    firebaseUser = null;
    user = null;
    await _authService.signOut();
  }

  Future<bool> signInWithGoogle() async {
    firebaseUser = await _authService.signInWithGoogle();

    user = await service.findUser(firebaseUser!.email!, firebaseUser!);
    return user != null;
  }

  // Future<bool> signInWithTwitter() async {
  //   firebaseUser = await _authService.signInWithTwitter();
  //   if (firebaseUser != null &&
  //       firebaseUser.providerData != null &&
  //       firebaseUser.providerData.isNotEmpty) {
  //     user = await service.findUser(
  //         firebaseUser.providerData[0].email, firebaseUser);
  //   }

  //   return user != null;
  // }

//  Future<bool> signInWithFacebook() async {
//    firebaseUser = await _authService.signInWithFacebook();
//    if (firebaseUser != null) {
//      user = await service.findUser(firebaseUser.email, firebaseUser);
//    }
//
//    return user != null;
//  }

  void changeUserProfilePicture(File file) {
    try {
      startLoading();
      service.updateUser(user!, profilePicture: file).then((updatedUser) {
        user!.profilePicture = updatedUser.profilePicture;
        user!.profilePictureURL = updatedUser.profilePictureURL;
        stopLoading();
      }).catchError((onError) {
        stopLoading();
      });
    } catch (e) {}
  }

  Future<void> updateUser() async {
    user = await service.updateUser(user!);
  }

  Future<void> register(
      {required String email,
        required String password,
        required String firstname,
        required String lastname}) async {
    firebaseUser =
        await _authService.register({"email": email, "password": password});
    await findUserInformation();
    user!.firstName = firstname;
    user!.surname = lastname;
    user!.fullName = "$firstname $lastname";
    await updateUser();
  }

  Future passwordReset({required String email}) async {
    if (email != null) {
      return _authService.recoverPassword(email);
    }
    return new Exception("Nothing is wrong");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _restaurantController.close();
    _barController.close();
    _salonController.close();
    _cafeControllers.close();
    _hotelController.close();
  }
}
