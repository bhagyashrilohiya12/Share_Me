import 'package:cpr_user/constants/cpr_routes.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/models/review_like.dart';
import 'package:cpr_user/models/user.dart';
import 'package:cpr_user/services/places_service.dart';
import 'package:cpr_user/services/review_like_service.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class ReviewListItem extends StatefulWidget {
  Review review;
  CPRReviewLike reviewLike;
  CPRUser loginedUser;
  Function showProgress;
  Function like;
  Function unlike;

  ReviewListItem(this.review, this.reviewLike, this.loginedUser, this.showProgress, this.like, this.unlike);

  @override
  _ReviewListItemState createState() => _ReviewListItemState();
}

class _ReviewListItemState extends State<ReviewListItem> {
  bool showProgressLikeUnlike = false; // for prevent double like or unlike

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.showProgress(true);
        var updatedPlace = await PlacesService().findPlaceById(widget.review.placeID!);
        Navigator.of(context).push(CPRRoutes.reviewDetailPage(widget.review, updatedPlace!));
        widget.showProgress(false);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black26, spreadRadius: 1, blurRadius: 3)]),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Row(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                child: Image(
                  image: getImageProvider(),
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 96,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.review.locationName ?? "",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              if (!showProgressLikeUnlike) {
                                if (widget.reviewLike != null)
                                  _unlikeReview();
                                else
                                  _likeReview();
                              }
                            },
                            child: showProgressLikeUnlike
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    child: Center(
                                      child: SpinKitThreeBounce(
                                        size: 8,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    widget.reviewLike != null ? FontAwesome.heart : FontAwesome.heart_o,
                                    color: widget.reviewLike != null ? Colors.red : Colors.black,
                                  ))
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      widget.review.address ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(widget.review.when != null
                        ? DateFormat('dd-MM-yyyy hh:mm a')
                            .format(widget.review.when!)
                        : "-"),
                    const Expanded(
                      child: Text(""),
                    ),
                    Row(
                      children: [
                        const Text("Waiting"),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            widget.review.waiting.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: rateColorPicker(
                                    widget.review.waiting!.toDouble())),
                          ),
                        ),
                        const Text("Rating"),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            widget.review.rating!.toInt().toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: rateColorPicker(widget.review.rating!)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color rateColorPicker(double rate) {
    if (rate != null && rate >= 4.0 && rate <= 5.0)
      return Colors.green;
    else if (rate != null && rate >= 3.0 && rate <= 3.9)
      return Colors.amber;
    else if (rate != null && rate < 3)
      return Colors.red;
    else
      return Colors.red;
  }

  _likeReview() async {
    setState(() {
      showProgressLikeUnlike = true;
    });
    ReviewLikeService reviewLikeService = new ReviewLikeService();
    var reviewLike = new CPRReviewLike(
        liker: widget.loginedUser, likerId: widget.loginedUser.email!, review: widget.review, reviewId: widget.review.firebaseId!);

    CPRReviewLike? reviewLikeTemp = await reviewLikeService.likeReview( reviewLike );
    if (reviewLikeTemp != null) widget.like(reviewLikeTemp);
    setState(() {
      showProgressLikeUnlike = false;
    });
  }

  _unlikeReview() async {
    setState(() {
      showProgressLikeUnlike = true;
    });
    ReviewLikeService reviewLikeService = new ReviewLikeService();
    bool unLiked = await reviewLikeService.unlikeReview(widget.reviewLike.id!);
    if (unLiked) widget.unlike(widget.reviewLike);
    setState(() {
      showProgressLikeUnlike = false;
    });
  }

  getImageProvider() {
    /**
     * #abdo
        widget.review.downloadURLs != null && widget.review.downloadURLs.length > 0
        ? NetworkImage(widget.review.downloadURLs[0])
        : AssetImage("assets/images/no_avatar_image_choosed.png")
     */

    if( ToolsValidation.isEmptyList( widget.review.downloadURLs  ) ) {
      return AssetImage( "assets/images/no_avatar_image_choosed.png");
    }

    //check have
    var first = widget.review.downloadURLs![0];
    if( ToolsValidation.isValid(    first  )  ) {
      return NetworkImage( first );
    }

    return  AssetImage( "assets/images/no_avatar_image_choosed.png");
  }
}
