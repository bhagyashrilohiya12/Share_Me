import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/constants/weighting.dart';
import 'package:cpr_user/helpers/image_helper.dart';
import 'package:cpr_user/helpers/location_helper.dart';
import 'package:cpr_user/helpers/user_helper.dart';
import 'package:cpr_user/models/added_place.dart';
import 'package:cpr_user/models/business_external_promotion.dart';
import 'package:cpr_user/models/business_internal_promotion.dart';
import 'package:cpr_user/models/external_promotion_coupon.dart';
import 'package:cpr_user/models/place.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/models/user_setting.dart';
import 'package:cpr_user/services/auth_service.dart';
import 'package:cpr_user/services/business_external_promotions_service.dart';
import 'package:cpr_user/services/business_internal_promotions_service.dart';
import 'package:cpr_user/services/external_promotions_coupon_service.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:cpr_user/services/reviews_service.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../models/added_place.dart';

class SessionProvider extends ChangeNotifier {
  User? firebaseUser;
  CPRUser? user;
  Map<MainCategory, List<dynamic>> places = {};  //carry all home pages places
  GeoPoint? currentLocation;
  var userLevel = Weighting.bronze;
  var service = UserService();
  var placeService = PlacesService();
  var _authService = AuthService();
  var imageHelper = ImageHelper();
  var businessInternalPromotionsService = BusinessInternalPromotionsService();
  var businessExternalPromotionsService = BusinessExternalPromotionsService();
  var externalPromotionsCouponService = ExternalPromotionsCouponService();

  List<CPRBusinessInternalPromotion>? internalPromotions;
  List<CPRBusinessExternalPromotion>? externalPromotions;
  List<CPRExternalPromotionCoupon> userCoupons = [];

  bool busy = false;
  var _currentIndex = 0;

  String  profileURL () {
    var str =  user != null ? user!.profilePictureURL! : null;
    return str!;
  }

  // String get profileURL => user != null ? user!.profilePictureURL! : null;

  int get reviewCount {
    if (user!.reviews != null) {
      return user!.reviews!.length;
    }
    return 0;
  }

  Future<int> get prizesCount async {
    List<String>? userPrizesAndCompetitionsIdsList =
        await ReviewService().findReviewsThatUsePromotionByUser(user!);
    List <CPRBusinessInternalPromotion> internalPromotionsTemp =
        await BusinessInternalPromotionsService().getInternalPromotionsFromIdsList(userPrizesAndCompetitionsIdsList!);
    int prizesCount = 0;
    internalPromotionsTemp.forEach((element){
      if(element.winReviews!=null && element.winReviews.isNotEmpty) {
        element.winReviews.forEach((elem){
          if(elem.userId==user!.email) {
            prizesCount++;
          }
        });
      }
    });
    return prizesCount;
  }

  int get saveForLaterCount {
    if (places[MainCategory.saveForLaterPlaces] != null) {
      return places[MainCategory.saveForLaterPlaces]!.length;
    }
    return 0;
  }

  int get favoritesCount {
    if (places[MainCategory.myFavoritePlaces] != null) {
      return places[MainCategory.myFavoritePlaces]!.length;
    }
    return 0;
  }

  int get prizes => 2;

  String get displayName => user != null && user!.displayName != null ? user!.displayName! : "";

  // SessionProvider({  User? user}) {
  //   if (user != null) {
  //     firebaseUser = user;
  //     findUserInformation();
  //   }
  // }

  get currentIndex => this._currentIndex;

  set currentIndex(index) {
    this._currentIndex = index;
    notifyListeners();
  }

  Future findUserInformation() async {
    try {
      user = (await service.findUser(firebaseUser!.email!, firebaseUser!))!;
      notifyListeners();
      if (user != null) {
        service.findInformation(user!.documentID).then((result) async {
          List<Review> reviews = await ReviewService().getUserReviewsList(user!);
          print("User information Loaded: ${DateTime.now()}");
          user!.drafts = result["draft"] as List<Review>;
          user!.reviews = reviews;
          user!.favorites = result["favorites"] as List<AddedPlace>;
          user!.saveForLater = result["sfl"] as List<AddedPlace>;
          refreshUserLevel();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future findCurrentLocation() async {
    try {

      //get last
      try {

        GeoPoint lastCurrent = await LocationHelper.lastKnownLocation();

        if( lastCurrent != null ) {
          Log.i( "findCurrentLocation()  - lastCurrent.latitude: " +  lastCurrent.latitude.toString()  );
          currentLocation = lastCurrent;
          return;
        } else {
          Log.i( "findCurrentLocation()  - lastCurrent is null"  );
        }
      } catch (e) {
        print(e);
        Log.i( "findCurrentLocation()  - lastCurrent e " + e.toString()  );
      }


      //set default user current
      if (currentLocation == null) {
        currentLocation = await LocationHelper.userLocation();
      }

      //log
      if( currentLocation != null ) {
        Log.i( "findCurrentLocation() - currentLocation.latitude: " +  currentLocation!.latitude.toString()  );
      }

    } catch (e) {
      print(e);
      Log.i( "findCurrentLocation()  - e: " +  e.toString() );
    }
  }

  Future addToCategory(Place place, MainCategory category) async {
    await service.addToCategory(user!, place, category);
    var list = await refreshCategory(category);
    var currentList = places[category];
    if (currentList == null) {
      places.putIfAbsent(category, () => list!);
    } else {
      places.update(category, (l) => list!);
    }

    notifyListeners();
  }

  Future removeFromCategory(Place place, MainCategory category) async {
    await service.removeFromCategory(user!, place, category);
    var list = await refreshCategory(category);
    var currentList = places[category];
    if (currentList == null) {
      places.putIfAbsent(category, () => list!);
    } else {
      places.update(category, (l) => list!);
    }
    notifyListeners();
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

  Future refreshSpecificCategory(MainCategory category) async {
    if (currentLocation != null) {
      placeService
          .getTopRateNearPlace(currentLocation!,MainCategoryUtil.getGooglePlacesName(category))
          .then((list) {
        if (list != null && list.isNotEmpty) {
          places.putIfAbsent(category, () => list);
          notifyListeners();
        }
      });
    }
  }

  bool isInCategory(Place place, MainCategory category) {
    try {
      var result = places[category]!.contains(place);
      return result;
    } catch (e) {}
    return false;
  }

  Future<String> loadCategorizedPlaces() async {
    var userId = user!.documentID;
    places = {};
    if (currentLocation == null) {
      print("Location: ${DateTime.now()}");
      await findCurrentLocation();
      print("Location after: ${DateTime.now()}");
    }
    try {
      if (userId != null) {
        for (MainCategory category in MainCategory.values) {
          try {
            if (MainCategoryUtil.isCategorized(category)) {
            //  print("Loading Category $category");
              refreshSpecificCategory(category);
            } else {
              switch (category) {
                case MainCategory.myFavoritePlaces:
                  placeService.findFavoritePlaces(userId).then((list) {
                    if (list != null) {
                      places.putIfAbsent(category, () => list);
                      notifyListeners();
                    }
                  });
                  break;

                case MainCategory.saveForLaterPlaces:
                  placeService.findSaveForLaterPlaces(userId).then((list) {
                    if (list != null) {
                      places.putIfAbsent(category, () => list);
                      notifyListeners();
                    }
                  });
                  break;
                case MainCategory.myReviews:
                  placeService.findReviewsPlaces(userId).then((list) {
                    if (list != null) {
                      places.putIfAbsent(category, () => list);
                      notifyListeners();
                    }
                  });
                  break;
                case MainCategory.myDraftReviews:
                  placeService.findDraftReviewsOfReviews(userId).then((list) {
                    if (list != null) {
                      places.putIfAbsent(category, () => list);
                      notifyListeners();
                    }
                  });
                  break;
                default:
                  break;
              }
            }
          } catch (e) {
            print("Error updating category: $category :  $e");
          }
        }
      }
      return "OK";
    } catch (e) {
      print(e);
      return "ERROR";
    }
  }

  Future refreshReviews() async {
    var list = await placeService.findReviewsPlaces(user!.documentID!);
    if (list != null && list.isNotEmpty) {
      places.remove(MainCategory.myReviews);
      places.putIfAbsent(MainCategory.myReviews, () => list);
    }
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

  Future<bool> signInWithEmailAndPassword(String user, String pass) async {
    firebaseUser = await _authService.signInWithUserAndPassword(username: user, password: pass);
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

    user = (await service.findUser(firebaseUser!.email!, firebaseUser! ))!;
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

  void changeUserProfilePicture ( File? file) {

    if( file == null ) {
      Log.i( "geUserProfilePicture() - file: " + file!.path );
      return;
    }
    Log.i( "geUserProfilePicture() - file: " + file.path );
    /**
     * #abdo
         ( File file) {

        (CroppedFile file) {
     */
    try {
      startLoading();
      service.updateUser(user!, profilePicture: file).then((updatedUser) {
        user!.profilePicture = updatedUser.profilePicture;
        user!.profilePictureURL = updatedUser.profilePictureURL;
        stopLoading();
      }).catchError((onError) {
        stopLoading();
        print(onError.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateUser() async {
    user = await service.updateUser(user!);
    notifyListeners();
  }

  Future<void> register(
      {required String email,
        required String password,
        required String username,
        required String firstName,
        required String lastName,
        required int gender,
        required int religion,
        required DateTime birthDate,
        required String zipCode,
        required String fcmToken}) async {

    firebaseUser = await _authService.register({"email": email, "password": password});
    await findUserInformation();
    user!.username = username;
    user!.firstName = firstName;
    user!.surname = lastName;
    user!.fullName = "$firstName $lastName";
    user!.dateOfBirth = birthDate;
    user!.gender = gender;
    user!.religion = religion;
    user!.zipCode = zipCode;
    user!.fcmToken = fcmToken;
    user!.setting = UserSetting(otherUserCanFollowMe: true, receiveNotificationWhenAUserFollowMe: true,optOutOfAllMarketingAndCommunications: true,optOutOfSaleOfData: true);
    await updateUser();
  }

  Future<void> refreshUserLevel() async {
    userLevel = findWeightingByReviews(user!.reviews!);
  }

  Future passwordReset({required String email}) async {
    if (email != null) {
      return _authService.recoverPassword(email);
    }
    return new Exception("Nothing is wrong");
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<List<CPRBusinessInternalPromotion>> getInternalPromotions() async {
    internalPromotions = await businessInternalPromotionsService.getInternalPromotions();
//    notifyListeners();
  return internalPromotions!;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<List<CPRBusinessExternalPromotion>> getExternalPromotions() async {
    externalPromotions = await businessExternalPromotionsService.getExternalPromotions();
//    notifyListeners();
  return externalPromotions!;
  }

  Future<List<CPRBusinessExternalPromotion>> getExternalAllPromotions() async {
    return await businessExternalPromotionsService.getExternalAllPromotions();
  }

  Future<List<CPRExternalPromotionCoupon>> getUserCoupons() async {
    userCoupons =  await externalPromotionsCouponService.getUserCoupons(user!.email!);
    return userCoupons;
  }


}
