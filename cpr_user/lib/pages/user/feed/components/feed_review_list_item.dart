import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/constants/main_categories.dart';
import 'package:cpr_user/models/feed_review.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/review_like.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/pages/user/profile/user_profile_page.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:cpr_user/services/review_like_service.dart';
import 'package:cpr_user/services/reviews_service.dart';
import 'package:cpr_user/services/user_service.dart';
import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class FeedReviewListItem extends StatelessWidget {

  FeedReview r;
  Function showProgress;
  Function showLikeProgress;
  Function like;
  Function unlike;
  CPRUser loginedUser;
  CPRReviewLike? reviewLike;

  FeedReviewListItem(this.r, this.showProgress, this.showLikeProgress, this.loginedUser, this.like, this.unlike);

  @override
  Widget build(BuildContext context) {
    try {
      reviewLike = r.likes!.firstWhere((element) => element.likerId == loginedUser.email);
    } catch (e) {
      print(e);
    }
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    showProgress(true);
                    UserService userService = new UserService();
                    CPRUser? user = await userService.getUserById(r.userID!);
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => UserProfilePage(user!)));
                    showProgress(false);
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 4),
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 56,
                              height: 56,
                              margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: r.user?.profilePictureURL == null
                                    ? Image(fit: BoxFit.cover, image: AssetImage("assets/images/no_avatar_image_choosed.png"))
                                    : CachedNetworkImage(
                                        imageUrl: r.userProfilePictureURL!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(width: 56, height: 56, child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(48, 16, 4, 4),
                              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                              decoration: BoxDecoration(color: Get.theme.accentColor, borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                (r.user?.username) ?? (r.user?.displayName) ?? (r.user?.fullName) ?? "Name Not Set",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () async {
                    showProgress(true);
                    var updatedPlace = await PlacesService().findPlaceById(r.placeID!);
                    var review = await ReviewService().findReview(r.firebaseId!);
                    Navigator.of(context).push(CPRRoutes.reviewDetailPage(review, updatedPlace!));
                    showProgress(false);
                  },
                  child: Text(
                    "Review Page",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                  )),
              SizedBox(width: 8),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 3 / 4,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(8, 32, 8, 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: getChildImage(context),


                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 1, spreadRadius: 1)]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                r.rating.toString(),
                                style: CPRTextStyles.buttonSmallWhite.copyWith(fontSize: 24, color: rateColorPicker(r.rating!.toDouble())),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: rateColorPicker(r.rating!.toDouble()),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 1, spreadRadius: 1)]),
                                height: 20,
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                  "Rating",
                                  style: CPRTextStyles.buttonSmallWhite.copyWith(fontSize: 10),
                                )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 1, spreadRadius: 1)]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                r.waiting!.toDouble().toString(),
                                style: CPRTextStyles.buttonSmallWhite.copyWith(fontSize: 24, color: rateColorPicker(r.waiting!.toDouble())),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: rateColorPicker(r.waiting!.toDouble()),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 1, spreadRadius: 1)]),
                                height: 20,
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                  "Wating",
                                  style: CPRTextStyles.buttonSmallWhite.copyWith(fontSize: 10),
                                )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 1, spreadRadius: 1)]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          height: 8,
                        ),
                        Image(
                          image: AssetImage(MainCategoryUtil.getPlacesIconFromNames(r.place!.categories!)),
                          width: 24,
                          height: 24,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: MainCategoryUtil.getPlacesColorFromNames(r.place!.categories!),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 1, spreadRadius: 1)]),
                          height: 20,
                          width: double.infinity,
                          child: Center(
                              child: Text(
                                MainCategoryUtil.getPlacesNameFromNames(r.place!.categories!),
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      if (!r.showLikeProgress!) {
                        if (reviewLike != null)
                          _unlikeReview();
                        else
                          _likeReview();
                      }
                    },
                    child: Container(
                        width: 24,
                        height: 24,
                        child: r.showLikeProgress!
                            ? SpinKitThreeBounce(
                                size: 8,
                                color: Colors.white,
                              )
                            : Icon(
                                reviewLike != null ? FontAwesome.heart : FontAwesome.heart_o,
                                color: reviewLike != null ? Colors.red : Colors.white,
                              ))),
                SizedBox(
                  width: 8,
                ),
                reviewLike != null
                    ? Text(
                        "You and ",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      )
                    : SizedBox(),
                Text(
                  r.likes != null && r.likes!.length > 0 ? (reviewLike != null ? r.likes!.length - 1 : r.likes!.length).toString() : "0",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  " Users Like This",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Expanded(child: Text("")),
//                Icon(Icons.save_alt)
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Text(
              r.locationName ?? "Business Name",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Text(
              r.fullReview ?? "No Review Description",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  getUserReviewLike() {
    try {
      reviewLike = r.likes!.firstWhere((element) => element.likerId == loginedUser.email);
    } catch (e) {
      print(e);
    }
  }

  Color rateColorPicker(double rate) {
    if (rate >= 4.0 && rate <= 5.0)
      return Colors.green;
    else if (rate >= 3.0 && rate <= 3.9)
      return Colors.amber;
    else if (rate < 3)
      return Colors.red;
    else
      return Colors.red;
  }

  _likeReview() async {
    showLikeProgress(true);
    Review review = new Review(
        address: r.address,
        archived: r.archived,
        businessDisplayName: r.businessDisplayName,
        category: r.category,
        comments: r.comments,
        companion: r.companion,
        downloadURLs: r.downloadURLs,
        firebaseId: r.firebaseId,
        fullReview: r.fullReview,
        images: r.images,
        location: r.location,
        place: r.place,
        placeID: r.placeID,
        locationName: r.locationName,
        rating: r.rating!.toDouble(),
        waiting: r.waiting,
        reasonOfVisit: r.reasonOfVisit,
        server: r.server,
        serverId: r.server?.id,
        serverName: r.server?.nickname,
        //todo check it with server
        title: r.title,
        userProfilePictureURL: r.userProfilePictureURL,
        userDisplayName: r.userDisplayName,
        service: r.service,
        userID: r.userID,
        creationTime: r.creationTime,
        when: r.when);

    ReviewLikeService reviewLikeService = new ReviewLikeService();
    CPRReviewLike? reviewLikeTemp = await reviewLikeService
        .likeReview(new CPRReviewLike(liker: loginedUser,
        likerId: loginedUser.email!,
        review: review,
        reviewId: r.firebaseId));
    if (reviewLikeTemp != null) like(reviewLikeTemp);

    showLikeProgress(false);
  }

  _unlikeReview() async {
    showLikeProgress(true);
    ReviewLikeService reviewLikeService = new ReviewLikeService();
    bool unLiked = await reviewLikeService.unlikeReview(reviewLike!.id!);
    if (unLiked) unlike(reviewLike);
    showLikeProgress(false);
  }
  getPlaceIcon(){

  }


  getChildImage(BuildContext context ) {
    bool isChooseCache = r.downloadURLs != null &&  (r.downloadURLs!.length) > 0;
    return  isChooseCache? CachedNetworkImage(
    imageUrl: r.downloadURLs!.first,
    fit: BoxFit.cover,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.width * 3 / 4,
    placeholder: (context, url) => Image(image: AssetImage("assets/images/bg_loading_image_gif.gif"),
    fit: BoxFit.cover,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.width * 3 / 4,),
    errorWidget: (context, url, error) => Icon(Icons.error),
    )
        : Image(
    image: AssetImage("assets/images/bg_image_not_available.jpg"),
    fit: BoxFit.cover,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.width * 3 / 4,
    );
  }



}


