import 'package:cpr_user/models/business_internal_promotion.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/user/home_page/components/categorized_places_list.dart';
import 'package:cpr_user/pages/user/internal_promotion_details_page/components/review_winner_item.dart';
import 'package:cpr_user/services/reviews_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class internalPromotionDetailPage extends StatefulWidget {
  CPRBusinessInternalPromotion internalPromotion;

  internalPromotionDetailPage(this.internalPromotion);

  @override
  _internalPromotionDetailPageState createState() => _internalPromotionDetailPageState();
}

class _internalPromotionDetailPageState extends State<internalPromotionDetailPage> {
  List<Review>? reviews;
  List<Review>? winnerReviews;

  @override
  void initState() {
    super.initState();
    getReviewsForThisPromotion();
    if (widget.internalPromotion.winReviews != null && widget.internalPromotion.winReviews.isNotEmpty)
      getReviewWinnersDetails();
  }

  @override
  Widget build(BuildContext context) {
    Log.i( "page - internalPromotionDetailPage - build");

    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: Get.width,
              height: Get.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_prize.jpg"),
                  fit: BoxFit.cover,
                ),
              )),
          Positioned(
            top: 50,
            right: 16,
            height: 42,
            child: Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                child: Text(
                  "Promotion Details",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Row(
              children: <Widget>[
                Material(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
          Container(
            // color: color,
            margin: EdgeInsets.fromLTRB(16, 112, 16, 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
            width: Get.width,
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                      child: Container(
                        height: Get.width / 2,
                        width: Get.width,
                        child: ExtendedImage.network(
                          widget.internalPromotion.pictureURL!,
                          fit: BoxFit.cover,
                          cache: true,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                            color: Colors.black38),
                        padding: EdgeInsets.all(16),
                        height: Get.width / 2,
                        width: Get.width,
                        child: Column(
                          children: [
                            Expanded(child: Text("")),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Text(
                                widget.internalPromotion.title!,
                                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(child: Text("")),
                            CountdownTimer(
                              endTime: widget.internalPromotion.endDate!.millisecondsSinceEpoch,
                              widgetBuilder: (_, time) {
                                if (time == null) {
                                  return Column(
                                    children: [
                                      Text(
                                        'See Winners',
                                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                      )
                                    ],
                                  );
                                }
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            '${time.days != null ? time.days.toString().padLeft(2, "0") : 0} days',
                                            style: TextStyle(color: Colors.white, fontSize: 18),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            '${time.min != null ? time.min.toString().padLeft(2, "0") : 0} min',
                                            style: TextStyle(color: Colors.white, fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Text(""),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: Text(
                                            '${time.hours != null ? time.hours.toString().padLeft(2, "0") : 0} hours',
                                            style: TextStyle(color: Colors.white, fontSize: 18),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            '${time.sec != null ? time.sec.toString().padLeft(2, "0") : 0} sec',
                                            style: TextStyle(color: Colors.white, fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text(
                    widget.internalPromotion.description!,
                    maxLines: 20,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Row(
                    children: [
                      Text(
                        "Reviews For This Promotion",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 24, 16, 0),
                  height: 144,
                  child: reviews != null
                      ? reviews!.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                return ReviewMiniCard(categoryName: "", review: reviews![i]);
                              },
                              itemCount: reviews!.length,
                            )
                          : Center(child: Text("No Reviews Yet!"))
                      : SpinKitThreeBounce(
                          color: Theme.of(context).accentColor,
                          size: 24,
                        ),
                ),
                if (widget.internalPromotion.winReviews != null && widget.internalPromotion.winReviews.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: Row(
                      children: [
                        Text(
                          "Winners",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                if (widget.internalPromotion.winReviews != null && widget.internalPromotion.winReviews.isNotEmpty)
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 24, 16, 0),
                    height: 156,
                    child: winnerReviews != null
                        ? winnerReviews!.isNotEmpty
                        ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return ReviewWinnerItem(review: winnerReviews![i],
                            promotionWinReview : widget.internalPromotion.winReviews.firstWhere((element) => element.reviewId==winnerReviews![i].firebaseId));
                      },
                      itemCount: winnerReviews!.length,
                    )
                        : Center(child: Text("No Winners Yet!"))
                        : SpinKitThreeBounce(
                      color: Theme.of(context).accentColor,
                      size: 24,
                    ),
                  ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  getReviewsForThisPromotion() async {
    ReviewService reviewService = new ReviewService();
    List<Review> reviewsTemp = await reviewService.getPromotionReviewsList(widget.internalPromotion.documentID!);
    setState(() {
      reviews = reviewsTemp;
    });
  }

  getReviewWinnersDetails() async {
    ReviewService reviewService = new ReviewService();
    List<Review> winnerReviewsTemp = await reviewService.getReviewsFromIdsList(widget.internalPromotion.winReviews.map((e) => e.reviewId!).toList());
    setState(() {
      winnerReviews = winnerReviewsTemp;
    });
  }
}
